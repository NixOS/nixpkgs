{ lib, fetchurl, stdenvNoCC, makeWrapper, jre }:

stdenvNoCC.mkDerivation rec {
  pname = "flix";
<<<<<<< HEAD
  version = "0.40.0";

  src = fetchurl {
    url = "https://github.com/flix/flix/releases/download/v${version}/flix.jar";
    sha256 = "sha256-NVQY2TgIR9ROy4x8PWxCjuaOkNx0bcUA4oZHjpQbHc4=";
=======
  version = "0.36.0";

  src = fetchurl {
    url = "https://github.com/flix/flix/releases/download/v${version}/flix.jar";
    sha256 = "sha256-HAhNNg8f+uC2QKYqkugJIyH7VakNA631S2/UE2vG+5M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    export JAR=$out/share/java/flix/flix.jar
    install -D $src $JAR
    makeWrapper ${jre}/bin/java $out/bin/flix \
      --add-flags "-jar $JAR"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Flix Programming Language";
    homepage = "https://github.com/flix/flix";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ athas ];
    inherit (jre.meta) platforms;
  };
}
