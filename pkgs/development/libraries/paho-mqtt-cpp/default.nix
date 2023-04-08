{ lib, stdenv, fetchFromGitHub, cmake, openssl, paho-mqtt-c }:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.cpp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.cpp";
    rev = "v${version}";
    hash = "sha256-tcq0a4X5dKE4rnczRMAVe3Wt43YzUKbxsv9Sk+q+IB8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl paho-mqtt-c ];

  meta = with lib; {
    description = "Eclipse Paho MQTT C++ Client Library";
    homepage = "https://www.eclipse.org/paho/";
    license = licenses.epl10;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
