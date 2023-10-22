{ stdenv
, lib
, autoPatchelfHook
, src
}:

stdenv.mkDerivation {
  inherit (src) name;
  inherit src;

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -r . "$out/bin/cache"

    runHook postInstall
  '';
}
