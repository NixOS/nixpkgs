{ pkgs, lib, gccStdenv, callPackage, fetchFromGitHub }:
# See ../gambit/build.nix regarding gccStdenv

rec {
  # Gerbil libraries
  gerbilPackages-unstable = {
    gerbil-libp2p = callPackage ./gerbil-libp2p.nix { };
    gerbil-utils = callPackage ./gerbil-utils.nix { };
    gerbil-crypto = callPackage ./gerbil-crypto.nix { };
    gerbil-poo = callPackage ./gerbil-poo.nix { };
    gerbil-persist = callPackage ./gerbil-persist.nix { };
    gerbil-ethereum = callPackage ./gerbil-ethereum.nix { };
    smug-gerbil = callPackage ./smug-gerbil.nix { };
  };

  # Use this function in any package that uses Gerbil libraries, to define the GERBIL_LOADPATH.
  gerbilLoadPath =
    gerbilInputs : builtins.concatStringsSep ":" (map (x : x + "/gerbil/lib") gerbilInputs);

  # Use this function to create a Gerbil library. See gerbil-utils as an example.
  gerbilPackage = {
    pname, version, src, meta, gerbil-package,
    git-version ? "", version-path ? "",
    gerbil ? pkgs.gerbil-unstable,
    gambit-params ? pkgs.gambit-support.stable-params,
    gerbilInputs ? [],
    nativeBuildInputs ? [],
    buildInputs ? [],
    buildScript ? "./build.ss",
    softwareName ? ""} :
    let buildInputs_ = buildInputs; in
    gccStdenv.mkDerivation rec {
      inherit src meta pname version nativeBuildInputs;
      passthru = { inherit gerbil-package version-path ;};
      buildInputs = [ gerbil ] ++ gerbilInputs ++ buildInputs_;
      postPatch = ''
        set -e ;
        if [ -n "${version-path}.ss" ] ; then
          echo -e '(import :clan/versioning${builtins.concatStringsSep ""
                     (map (x : lib.optionalString (x.passthru.version-path != "")
                               " :${x.passthru.gerbil-package}/${x.passthru.version-path}")
                          gerbilInputs)
                     })\n(register-software "${softwareName}" "v${git-version}")\n' > "${passthru.version-path}.ss"
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
        ${buildScript}
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
