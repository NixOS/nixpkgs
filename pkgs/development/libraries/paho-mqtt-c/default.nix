{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.c";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.c";
    rev = "v${version}";
    hash = "sha256-dKQnepQAryAjImh2rX1jdgiKBtJQy9wzk/7rGQjUtPg=";
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
