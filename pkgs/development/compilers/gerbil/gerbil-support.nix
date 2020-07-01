{ pkgs, gccStdenv, callPackage, fetchFromGitHub }:
# See ../gambit/build.nix regarding gccStdenv

rec {
  # Gerbil libraries
  gerbilPackages-unstable = {
    gerbil-utils = callPackage ./gerbil-utils.nix { };
  };

  # Use this function in any package that uses Gerbil libraries, to define the GERBIL_LOADPATH.
  gerbilLoadPath =
    gerbilInputs : builtins.concatStringsSep ":" (map (x : x + "/gerbil/lib") gerbilInputs);

  # Use this function to create a Gerbil library. See gerbil-utils as an example.
  gerbilPackage = {
    pname, version, src, meta, package,
    git-version ? "", version-path ? "config/version.ss",
    gerbil ? pkgs.gerbil-unstable,
    gambit-params ? pkgs.gambit-support.stable-params,
    gerbilInputs ? [],
    buildInputs ? [],
    softwareName ? "" } :
    let buildInputs_ = buildInputs; in
    gccStdenv.mkDerivation rec {
      inherit src meta pname version;
      buildInputs = [ gerbil ] ++ gerbilInputs ++ buildInputs_;
      postPatch = ''
        set -e ;
        if [ -n "${version-path}" ] ; then
          echo '(import :clan/utils/version)\n(register-software "${softwareName}" "${git-version}")\n' > "${version-path}"
        fi
        patchShebangs . ;
      '';

      postConfigure = ''
        export GERBIL_BUILD_CORES=$NIX_BUILD_CORES
        export GERBIL_PATH=$PWD/.build
        export GERBIL_LOADPATH=${gerbilLoadPath gerbilInputs}
        ${pkgs.gambit-support.export-gambopt gambit-params}
      '';

      buildPhase = ''
        runHook preBuild
        ./build.ss
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/gerbil/lib
        cp -fa .build/lib $out/gerbil/
        bins=(.build/bin/*)
        if [ 0 -lt ''${#bins} ] ; then
          cp -fa .build/bin $out/gerbil/
          mkdir $out/bin
          cd $out/bin
          ln -s ../gerbil/bin/* .
        fi
        runHook postInstall
      '';

      dontFixup = true;
    };
}
