{ stdenv, buildPackages, callPackage }:

let
  chezSystemMap = {
    # See `/workarea` of source code for list of systems
    "aarch64-darwin" = "tarm64osx";
    "aarch64-linux" = "tarm64le";
    "armv7l-linux" = "tarm32le";
    "x86_64-darwin" = "ta6osx";
    "x86_64-linux" = "ta6le";
  };
  inherit (stdenv.hostPlatform) system;
  chezSystem = chezSystemMap.${system} or (throw "Add ${system} to chezSystemMap to enable building chez-racket");
  # Chez Scheme uses an ad-hoc `configure`, hence we don't use the usual
  # stdenv abstractions.
  forBoot = {
    pname = "chez-scheme-racket-boot";
    configurePhase = ''
      runHook preConfigure
      ./configure --pb ZLIB=$ZLIB LZ4=$LZ4
      runHook postConfigure
    '';
    makeFlags = [ "${chezSystem}.bootquick" ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      pushd boot
      mv $(ls -1 | grep -v "^pb$") -t $out
      popd
      runHook postInstall
    '';
  };
  boot = buildPackages.callPackage (import ./shared.nix forBoot) {};
  forFinal = {
    pname = "chez-scheme-racket";
    configurePhase = ''
      runHook preConfigure
      cp -r ${boot}/* -t ./boot
      ./configure -m=${chezSystem} --installprefix=$out --installman=$out/share/man ZLIB=$ZLIB LZ4=$LZ4
      runHook postConfigure
    '';
    preBuild = ''
      pushd ${chezSystem}/c
    '';
    postBuild = ''
      popd
    '';
    setupHook = ./setup-hook.sh;
  };
  final = callPackage (import ./shared.nix forFinal) {};
in
final
