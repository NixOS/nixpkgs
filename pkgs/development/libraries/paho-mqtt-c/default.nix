{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.c";
  version = "1.3.12";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.c";
    rev = "v${version}";
    hash = "sha256-LxyMbMA6Antt8Uu4jCvmvYT9+Vm4ZUVz4XXFdd0O7Kk=";
  };

  postPatch = ''
    substituteInPlace src/MQTTVersion.c \
      --replace "namebuf[60]" "namebuf[120]" \
      --replace "lib%s" "$out/lib/lib%s"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [ "-DPAHO_WITH_SSL=TRUE" ];

  meta = with lib; {
    description = "Eclipse Paho MQTT C Client Library";
    homepage = "https://www.eclipse.org/paho/";
    license = licenses.epl20;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
