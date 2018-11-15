{ stdenv, lib, writeScript, buildFHSUserEnv, julia-manifest }:

with builtins;
let commonTargetPkgs = pkgs: with pkgs; [
    /* gnumake
    gcc
    clang
    python
    gfortran
    perl
    m4
    gawk
    git
    patch
    cmake
    pkgconfig
    mkl */
    wget
    julia
  ];

  /* setupHook = writeText "setup-hook.sh" ''
    addOpenmp() {
        addToSearchPath LD_LIBRARY_PATH ${openmp}/lib
    }
    addEnvHooks "$targetOffset" addOpenmp
  ''; */
in
buildFHSUserEnv {
  name = "julia-chroot";
  targetPkgs = commonTargetPkgs;
  extraBuildCommands = ''
    FILE="${julia-manifest}"
    DIR="$(dirname "$FILE")"
    mkdir -p $DIR
    if [ ! -f $FILE ]; then
      echo "Creating empty $FILE"
      touch $FILE
    fi
  '';

  passthru.run = buildFHSUserEnv {
    name = "julia-run";

    targetPkgs = commonTargetPkgs;

    runScript = writeScript "julia-run" ''
      #!${stdenv.shell}
      shift
      exec -- julia "$@"
    '';
  };

  passthru.rebuild = buildFHSUserEnv {
    name = "julia-rebuild";

    targetPkgs = commonTargetPkgs;

    runScript = writeScript "julia-rebuild" ''
      #!${stdenv.shell}
      cp ${julia-manifest} ${getEnv "HOME"}/.julia/environments/v1.0/Manifest.toml
      julia -e "using Pkg; Pkg.instantiate()"
    '';
  };
}
