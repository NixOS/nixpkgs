{ lib
, stdenv
, cmake
, fetchFromGitHub
, fetchMavenArtifact
, jdk11
, libbsd
, libuuid
, makeWrapper
, pkg-config
, zlib
}:

let
  pname = "aeron-cpp";
  version = "1.40.0";

  agrona = fetchMavenArtifact {
    version = "1.17.1";
    artifactId = "agrona";
    groupId = "org.agrona";
    sha256 = "sha256-ym/3Y/2T3c9d0ri59g3Jd6LWRPHxZm/9nPf9Y3q20/0=";
  };

  sbeTool = fetchMavenArtifact {
    version = "1.27.0";
    artifactId = "sbe-tool";
    groupId = "uk.co.real-logic";
    sha256 = "sha256-nysjp+9cuM4cRz5kHk3U/R6nnyFq9Worql69tZQwv4A=";
  };

  src = fetchFromGitHub {
    owner = "real-logic";
    repo = "aeron";
    rev = version;
    sha256 = "sha256-4C5YofA/wxwa7bfc6IqsDrw8CLQWKoVBCIe8Ec7ifAg=";
  };

  codecs = stdenv.mkDerivation {
    name = "${pname}-codecs";
    inherit src;

    nativeBuildInputs = [
      jdk11
    ];

    buildPhase = ''
      "${jdk11}/bin/java" \
        -cp "${sbeTool.jar}:${agrona.jar}" \
        -Dsbe.output.dir="$out" \
        -Dsbe.target.language=Cpp \
        -Dsbe.target.namespace=aeron.archive.client \
        -Dsbe.validation.xsd=aeron-archive/src/main/resources/archive/fpl/sbe.xsd \
        -Dsbe.validation.stop.on.error=true \
        uk.co.real_logic.sbe.SbeTool \
        aeron-archive/src/main/resources/archive/aeron-archive-codecs.xml
    '';

    dontInstall = true;
  };

in

stdenv.mkDerivation rec {
  inherit pname src version;

  buildInputs = [
    libbsd
    libuuid
    zlib
  ];

  nativeBuildInputs = [
    codecs
    cmake
    jdk11
    makeWrapper
    pkg-config
  ];

  patches = [
    ./0001-jar.patch
    ./0002-codecs.patch
  ];

  cmakeFlags = [
    "-DAERON_TESTS=OFF"
    "-DAERON_SYSTEM_TESTS=OFF"
  ];

  preBuild = ''
    ln --symbolic "${codecs}" generated
  '';

  meta = with lib; {
    description = "Low-latency messaging library";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.vaci ];
  };
}

