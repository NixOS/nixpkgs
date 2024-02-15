{ lib
, callPackage
, runCommand
, fetchFromGitHub
, fetchgit
, fontconfig
, git
, makeWrapper
, writeText
, writeTextFile
, python3

# Artifacts dependencies
, fetchurl
, glibc
, pkgs
, stdenv

, julia

# Special registry which is equal to JuliaRegistries/General, but every Versions.toml
# entry is augmented with a Nix sha256 hash
, augmentedRegistry ? callPackage ./registry.nix {}

# Other overridable arguments
, extraLibs ? []
, precompile ? true
, setDefaultDepot ? true
, makeWrapperArgs ? ""
, packageOverrides ? {}
, makeTransitiveDependenciesImportable ? false # Used to support symbol indexing
}:

packageNames:

let
  util = callPackage ./util.nix {};

in

let
  # Some Julia packages require access to Python. Provide a Nixpkgs version so it
  # doesn't try to install its own.
  pythonToUse = let
    extraPythonPackages = ((callPackage ./extra-python-packages.nix { inherit python3; }).getExtraPythonPackages packageNames);
  in (if extraPythonPackages == [] then python3
      else util.addPackagesToPython python3 (map (pkg: lib.getAttr pkg python3.pkgs) extraPythonPackages));

  # Start by wrapping Julia so it has access to Python and any other extra libs.
  # Also, prevent various packages (CondaPkg.jl, PythonCall.jl) from trying to do network calls.
  juliaWrapped = runCommand "julia-${julia.version}-wrapped" { buildInputs = [makeWrapper]; inherit makeWrapperArgs; } ''
    mkdir -p $out/bin
    makeWrapper ${julia}/bin/julia $out/bin/julia \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLibs}" \
      --set FONTCONFIG_FILE ${fontconfig.out}/etc/fonts/fonts.conf \
      --set PYTHONHOME "${pythonToUse}" \
      --prefix PYTHONPATH : "${pythonToUse}/${pythonToUse.sitePackages}" \
      --set PYTHON ${pythonToUse}/bin/python $makeWrapperArgs \
      --set JULIA_CONDAPKG_OFFLINE yes \
      --set JULIA_CONDAPKG_BACKEND Null \
      --set JULIA_PYTHONCALL_EXE "@PyCall"
  '';

  # If our closure ends up with certain packages, add others.
  packageImplications = {
    # Because we want to put PythonCall in PyCall mode so it doesn't try to download
    # Python packages
    PythonCall = ["PyCall"];
  };

  # Invoke Julia resolution logic to determine the full dependency closure
  packageOverridesRepoified = lib.mapAttrs util.repoifySimple packageOverrides;
  closureYaml = callPackage ./package-closure.nix {
    inherit augmentedRegistry julia packageNames packageImplications;
    packageOverrides = packageOverridesRepoified;
  };

  # Generate a Nix file consisting of a map from dependency UUID --> package info with fetchgit call:
  # {
  #   "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3" = {
  #     src = fetchgit {...};
  #     name = "...";
  #     version = "...";
  #     treehash = "...";
  #   };
  #   ...
  # }
  dependencies = runCommand "julia-sources.nix" { buildInputs = [(python3.withPackages (ps: with ps; [toml pyyaml])) git]; } ''
    python ${./python}/sources_nix.py \
      "${augmentedRegistry}" \
      '${lib.generators.toJSON {} packageOverridesRepoified}' \
      "${closureYaml}" \
      "$out"
  '';

  # Import the Nix file from the previous step (IFD) and turn each dependency repo into
  # a dummy Git repository, as Julia expects. Format the results as a YAML map from
  # dependency UUID -> Nix store location:
  # {
  #   "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3":"/nix/store/...-NaNMath.jl-0877504",
  #   ...
  # }
  # This is also the point where we apply the packageOverrides.
  dependencyUuidToInfo = import dependencies { inherit fetchgit; };
  fillInOverrideSrc = uuid: info:
    if lib.hasAttr info.name packageOverrides then (info // { src = lib.getAttr info.name packageOverrides; }) else info;
  dependencyUuidToRepo = lib.mapAttrs util.repoifyInfo (lib.mapAttrs fillInOverrideSrc dependencyUuidToInfo);
  dependencyUuidToRepoYaml = writeTextFile {
    name = "dependency-uuid-to-repo.yml";
    text = lib.generators.toYAML {} dependencyUuidToRepo;
  };

  # Given the augmented registry, closure info yaml, and dependency path yaml, construct a complete
  # Julia registry containing all the necessary packages
  dependencyUuidToInfoYaml = writeTextFile {
    name = "dependency-uuid-to-info.yml";
    text = lib.generators.toYAML {} dependencyUuidToInfo;
  };
  fillInOverrideSrc' = uuid: info:
    if lib.hasAttr info.name packageOverridesRepoified then (info // { src = lib.getAttr info.name packageOverridesRepoified; }) else info;
  overridesOnly = lib.mapAttrs fillInOverrideSrc' (lib.filterAttrs (uuid: info: info.src == null) dependencyUuidToInfo);
  minimalRegistry = runCommand "minimal-julia-registry" { buildInputs = [(python3.withPackages (ps: with ps; [toml pyyaml])) git]; } ''
    python ${./python}/minimal_registry.py \
      "${augmentedRegistry}" \
      "${closureYaml}" \
      '${lib.generators.toJSON {} overridesOnly}' \
      "${dependencyUuidToRepoYaml}" \
      "$out"
  '';

  # Next, deal with artifacts. Scan each artifacts file individually and generate a Nix file that
  # produces the desired Overrides.toml.
  artifactsNix = runCommand "julia-artifacts.nix" { buildInputs = [(python3.withPackages (ps: with ps; [toml pyyaml]))]; } ''
    python ${./python}/extract_artifacts.py \
      "${dependencyUuidToRepoYaml}" \
      "${closureYaml}" \
      "${juliaWrapped}/bin/julia" \
      "${if lib.versionAtLeast julia.version "1.7" then ./extract_artifacts.jl else ./extract_artifacts_16.jl}" \
      '${lib.generators.toJSON {} (import ./extra-libs.nix)}' \
      "$out"
  '';

  # Import the artifacts Nix to build Overrides.toml (IFD)
  artifacts = import artifactsNix { inherit lib fetchurl pkgs glibc stdenv; };
  overridesJson = writeTextFile {
    name = "Overrides.json";
    text = lib.generators.toJSON {} artifacts;
  };
  overridesToml = runCommand "Overrides.toml" { buildInputs = [(python3.withPackages (ps: with ps; [toml]))]; } ''
    python ${./python}/format_overrides.py \
      "${overridesJson}" \
      "$out"
  '';

  # Build a Julia project and depot. The project contains Project.toml/Manifest.toml, while the
  # depot contains package build products (including the precompiled libraries, if precompile=true)
  projectAndDepot = callPackage ./depot.nix {
    inherit closureYaml extraLibs overridesToml packageImplications precompile;
    julia = juliaWrapped;
    registry = minimalRegistry;
    packageNames = if makeTransitiveDependenciesImportable
      then lib.mapAttrsToList (uuid: info: info.name) dependencyUuidToInfo
      else packageNames;
  };

in

runCommand "julia-${julia.version}-env" {
  buildInputs = [makeWrapper];

  inherit julia;
  inherit juliaWrapped;
  meta = julia.meta;

  # Expose the steps we used along the way in case the user wants to use them, for example to build
  # expressions and build them separately to avoid IFD.
  inherit dependencies;
  inherit closureYaml;
  inherit dependencyUuidToInfoYaml;
  inherit dependencyUuidToRepoYaml;
  inherit minimalRegistry;
  inherit artifactsNix;
  inherit overridesJson;
  inherit overridesToml;
  inherit projectAndDepot;
} (''
  mkdir -p $out/bin
  makeWrapper ${juliaWrapped}/bin/julia $out/bin/julia \
    --suffix JULIA_DEPOT_PATH : "${projectAndDepot}/depot" \
    --set-default JULIA_PROJECT "${projectAndDepot}/project" \
    --set-default JULIA_LOAD_PATH '@:${projectAndDepot}/project/Project.toml:@v#.#:@stdlib'
'' + lib.optionalString setDefaultDepot ''
  sed -i '2 i\JULIA_DEPOT_PATH=''${JULIA_DEPOT_PATH-"$HOME/.julia"}' $out/bin/julia
'')
