{
  lib,
  runCommand,

  cacert,
  curl,
  git,
  julia,
  python3,
  stdenv,

  closureYaml,
  extraLibs,
  juliaCpuTarget,
  overridesToml,
  packageImplications,
  project,
  precompile,
  registry,
}:

let
  # On darwin, we don't want to specify JULIA_SSL_CA_ROOTS_PATH. If we do (using a -bin julia derivation, which is the
  # only kind darwin currently supports), you get an error like this:
  #
  # GitError(Code:ERROR, Class:SSL, Your Julia is built with a SSL/TLS engine that libgit2 doesn't know how to configure
  # to use a file or directory of certificate authority roots, but your environment specifies one via the SSL_CERT_FILE
  # variable. If you believe your system's root certificates are safe to use, you can `export JULIA_SSL_CA_ROOTS_PATH=""`
  # in your environment to use those instead.)
  setJuliaSslCaRootsPath =
    if stdenv.targetPlatform.isDarwin then
      ''export JULIA_SSL_CA_ROOTS_PATH=""''
    else
      ''export JULIA_SSL_CA_ROOTS_PATH="${cacert}/etc/ssl/certs/ca-bundle.crt"'';

in

runCommand "julia-depot"
  {
    nativeBuildInputs = [
      curl
      git
      julia
      (python3.withPackages (ps: with ps; [ pyyaml ]))
    ]
    ++ extraLibs;
    inherit precompile project registry;
  }
  (
    ''
      export HOME=$(pwd)

      echo "Building Julia depot and project with the following inputs"
      echo "Julia: ${julia}"
      echo "Project: $project"
      echo "Registry: $registry"
      echo "Overrides ${overridesToml}"

      mkdir -p $out/project
      export JULIA_PROJECT="$out/project"
      cp "$project/Manifest.toml" "$JULIA_PROJECT/Manifest.toml"
      cp "$project/Project.toml" "$JULIA_PROJECT/Project.toml"

      mkdir -p $out/depot/artifacts
      export JULIA_DEPOT_PATH="$out/depot"
      cp ${overridesToml} $out/depot/artifacts/Overrides.toml

      # These can be useful to debug problems
      # export JULIA_DEBUG=Pkg,loading

      ${setJuliaSslCaRootsPath}

      # Only precompile if configured to below
      export JULIA_PKG_PRECOMPILE_AUTO=0
    ''
    + lib.optionalString (juliaCpuTarget != null) ''
      export JULIA_CPU_TARGET="${juliaCpuTarget}"
    ''
    + ''
      # Prevent a warning where Julia tries to download package server info
      export JULIA_PKG_SERVER=""

      # See if we need to add any extra package names based on the closure
      # and the packageImplications. We're using the full closure YAML here since
      # it's available, which is slightly weird, but it should work just as well
      # for finding the extra packages we need to add
      python ${./python}/find_package_implications.py "${closureYaml}" '${
        lib.generators.toJSON { } packageImplications
      }' extra_package_names.txt

      # Work around new git security features added in git 2.44.1
      # See https://github.com/NixOS/nixpkgs/issues/315890
      git config --global --add safe.directory '*'

      # Tell Julia to use the Git binary we provide, rather than internal libgit2.
      export JULIA_PKG_USE_CLI_GIT="true"

      # At time of writing, this appears to be the only way to turn precompiling's
      # terminal output into standard logging, so opportunistically do that.
      # (Note this is different from JULIA_CI).
      export CI=true

      julia -e ' \
        import Pkg
        import Pkg.Types: PRESERVE_NONE

        Pkg.Registry.add(Pkg.RegistrySpec(path="${registry}"))

        # No need to Pkg.activate() since we set JULIA_PROJECT above
        println("Running Pkg.instantiate()")
        Pkg.instantiate()

        # Build is a separate step from instantiate.
        # Needed for packages like Conda.jl to set themselves up.
        println("Running Pkg.build()")
        Pkg.build()

        if "precompile" in keys(ENV) && ENV["precompile"] != "0" && ENV["precompile"] != ""
          if isdefined(Sys, :CPU_NAME)
            println("Precompiling with CPU_NAME = " * Sys.CPU_NAME)
          end

          Pkg.precompile()
        end

        # Remove the registry to save space
        Pkg.Registry.rm("General")
      '
    ''
  )
