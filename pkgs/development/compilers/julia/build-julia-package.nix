{ lib
, stdenv
, config
, patchelf
, julia
, computeRequiredJuliaPackages
, computeJuliaDepotPath
, computeJuliaLoadPath
, computeJuliaArtifacts
, xvfb-run
}:

# Build an individual package
{ fullPkgName ? "${attrs.pname}-${attrs.version}"

, src

, dontPatch ? false
, patches ? []
, patchPhase ? ""

, enableParallelBuilding ? true
# Build-time dependencies for the package, which were compiled for the system compiling this.
, nativeBuildInputs ? []

# Build-time dependencies for the package, which may not have been compiled for the system compiling this.
, buildInputs ? []

# Propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
# Run-time dependencies for the package.
, propagatedBuildInputs ? []

# Julia packages that are required at runtime for this one.
# These behave similarly to propagatedBuildInputs, where if
# package A is needed by B, and C needs B, then C also requires A.
# The main difference between these and propagatedBuildInputs is
# during the package's installation into Julia, where all
# requiredJuliaPackages are ALSO installed into Julia.
, requiredJuliaPackages ? []

, preBuild ? ""
, meta ? {}
, passthru ? {}

# Julia packages can distribute 'Artifacts'.  These can be some data,
# binary, ...  We Package 'Artifacts' as independent derivations. They
# differ from the rest of the packages in that they don't get compiled
# and the package providing it expect to find them in a specific location.
, isJuliaArtifact ? false
, ... } @ attrs:

let
  requiredJuliaPackages' = computeRequiredJuliaPackages requiredJuliaPackages;
  juliaDepotPath = computeJuliaDepotPath requiredJuliaPackages';
  juliaLoadPath = computeJuliaLoadPath requiredJuliaPackages';
  juliaArtifacts = computeJuliaArtifacts requiredJuliaPackages';


  # Must use attrs.nativeBuildInputs before they are removed by the removeAttrs
  # below, or everything fails.
  nativeBuildInputs' = [ julia patchelf ] ++ nativeBuildInputs;

  # This step is required because when
  # a = { test = [ "a" "b" ]; }; b = { test = [ "c" "d" ]; };
  # (a // b).test = [ "c" "d" ];
  # This used to mean that if a package defined extra nativeBuildInputs, it
  # would override the ones for building a Julia package (Julia itself)
  # causing everything to fail.
  attrs' = builtins.removeAttrs attrs [ "nativeBuildInputs" ];

in stdenv.mkDerivation ({
  packageName = "${fullPkgName}";
  # The name of the package ends up being
  # "julia-version-package-version"
  name = "${julia.pname}-${julia.version}-${fullPkgName}";

  # This states that any package built with the function that this returns
  # will be a julia package. This is used for ensuring other julia
  # packages are installed into julia during the environment building phase.
  isJuliaPackage = true;
  # Julia Artifacts need to be treated specially.
  isJuliaArtifact = isJuliaArtifact;

  inherit src;

  inherit dontPatch patches patchPhase;

  enableParallelBuilding = enableParallelBuilding;

  requiredJuliaPackages = requiredJuliaPackages';

  nativeBuildInputs = nativeBuildInputs';

  buildInputs = buildInputs ++ requiredJuliaPackages' ++ [ stdenv.cc.libc ];

  propagatedBuildInputs = propagatedBuildInputs;

  preUnpack = ''
    mkdir ${attrs.pname}
    cd ${attrs.pname}
  '';

  setSourceRoot = ''
    sourceRoot=$PWD
  '';

  # Set NIX_JULIA_PRECMD to the currntly only known command needed so
  # as to maximize the number of packages that compile without extra
  # configuration (see https://github.com/JuliaGraphics/Gtk.jl/issues/346)
  configurePhase = ''
    runHook preConfigure
    export NIX_JULIA_PRECMD=${xvfb-run}/bin/xvfb-run
    runHook postConfigure
  '';

  # Julia installs compiled cache in the first path in DEPOT_PATH.
  # Packages are pre-complied when imported.
  buildPhase = if isJuliaArtifact then ''
    runHook preBuild

    mkdir -p $out/share/julia/artifacts/${attrs.juliaPath}
    cp -r * $out/share/julia/artifacts/${attrs.juliaPath}

    runHook postBuild
  '' else ''
    runHook preBuild

    mkdir -p $out/share/julia/packages/${attrs.pname}
    cp -r * $out/share/julia/packages/${attrs.pname}

    export JULIA_LOAD_PATH=$out/share/julia/packages:${juliaLoadPath}:$JULIA_LOAD_PATH
    export JULIA_DEPOT_PATH=$out/share/julia:${julia}/share/julia:${juliaDepotPath}

    mkdir -p $out/share/julia/artifacts
    for path in ${lib.concatMapStringsSep " " (p: p + "/share/julia/artifacts/*") juliaArtifacts}; do
        ln -s $path $out/share/julia/artifacts/$(basename $path);
    done

    pushd $out/share/julia/packages/${attrs.pname}
    if [[ -f ./deps/build.jl ]]; then
      pushd deps
      $NIX_JULIA_PRECMD julia -- build.jl
      popd
    fi
    $NIX_JULIA_PRECMD julia -e 'import ${attrs.pname}'
    popd

    # these may cause collisions
    rm -r $out/share/julia/logs || true
    rm -r $out/share/julia/scratchspaces || true

    runHook postBuild
  '';

  # Need to install before building
  dontInstall = true;

  # Patch interpreter of bundled binary files
  postFixup = if isJuliaArtifact  then ''
    if [[ -d "$out"/share/julia/artifacts/${attrs.juliaPath}/bin ]]; then
      for fn in $(echo $out/share/julia/artifacts/${attrs.juliaPath}/bin/*); do
          isELF $fn && patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $fn || true
      done;
    fi
  '' else "";

  inherit meta;
} // attrs')
