{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "tika-server-standard";
  version = "2.9.0";

  src = fetchurl {
    url = "https://dlcdn.apache.org/tika/${version}/tika-server-standard-${version}.jar";
    hash = "sha256-7BoXwaI9cstYX/OGT8h1gYLfbobmNkRt7QIgeEvPhes=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    cp ${src} "$out/share/tika-server-standard.jar"

    makeWrapper ${jre}/bin/java $out/bin/tika-server-standard \
      --add-flags "-jar $out/share/tika-server-standard.jar" \
      --prefix PATH ":" ${ lib.makeBinPath [ jre ] }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Detects and extracts metadata and text from over a thousand different file types";
    homepage = "https://tika.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
    platforms = jre.meta.platforms;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}

