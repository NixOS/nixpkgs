{ lib
, runCommand

, cacert
, curl
, git
, julia
, python3

, closureYaml
, extraLibs
, overridesToml
, packageNames
, packageImplications
, precompile
, registry
}:

runCommand "julia-depot" {
    nativeBuildInputs = [curl git julia (python3.withPackages (ps: with ps; [pyyaml]))] ++ extraLibs;
    inherit precompile registry;
  } ''
  export HOME=$(pwd)

  echo "Building Julia depot and project with the following inputs"
  echo "Julia: ${julia}"
  echo "Registry: $registry"
  echo "Overrides ${overridesToml}"

  mkdir -p $out/project
  export JULIA_PROJECT="$out/project"

  mkdir -p $out/depot/artifacts
  export JULIA_DEPOT_PATH="$out/depot"
  cp ${overridesToml} $out/depot/artifacts/Overrides.toml

  # These can be useful to debug problems
  # export JULIA_DEBUG=Pkg
  # export JULIA_DEBUG=loading

  export JULIA_SSL_CA_ROOTS_PATH="${cacert}/etc/ssl/certs/ca-bundle.crt"

  # Only precompile if configured to below
  export JULIA_PKG_PRECOMPILE_AUTO=0

  # Prevent a warning where Julia tries to download package server info
  export JULIA_PKG_SERVER=""

  # See if we need to add any extra package names based on the closure
  # and the packageImplications. We're using the full closure YAML here since
  # it's available, which is slightly weird, but it should work just as well
  # for finding the extra packages we need to add
  python ${./python}/find_package_implications.py "${closureYaml}" '${lib.generators.toJSON {} packageImplications}' extra_package_names.txt

  # git config --global --add safe.directory '/nix'
  export JULIA_PKG_USE_CLI_GIT="true"

  julia -e ' \
    import Pkg
    import Pkg.Types: PRESERVE_NONE

    Pkg.Registry.add(Pkg.RegistrySpec(path="${registry}"))

    input = ${lib.generators.toJSON {} packageNames} ::Vector{String}

    if isfile("extra_package_names.txt")
      append!(input, readlines("extra_package_names.txt"))
    end

    input = unique(input)

    if !isempty(input)
      println("Adding packages: " * join(input, " "))
      Pkg.add(input; preserve=PRESERVE_NONE)
      Pkg.instantiate()

      if "precompile" in keys(ENV) && ENV["precompile"] != "0" && ENV["precompile"] != ""
        Pkg.precompile()
      end
    end

    # Remove the registry to save space
    Pkg.Registry.rm("General")
  '
''
