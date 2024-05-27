{ lib, stdenv, fetchFromGitHub, cmake, openssl, paho-mqtt-c, enableStatic ? stdenv.hostPlatform.isStatic, enableShared ? !stdenv.hostPlatform.isStatic }:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.cpp";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.cpp";
    rev = "v${version}";
    hash = "sha256-c2umToT4w+L7bgzp1bCEcb0ECHvxKZ2t6JI5SmUySPo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl paho-mqtt-c ];

  cmakeFlags = [
    (lib.cmakeBool "PAHO_WITH_SSL" true)
    (lib.cmakeBool "PAHO_BUILD_STATIC" enableStatic)
    (lib.cmakeBool "PAHO_BUILD_SHARED" enableShared)
  ];

  meta = with lib; {
    description = "Eclipse Paho MQTT C++ Client Library";
    homepage = "https://www.eclipse.org/paho/";
    license = licenses.epl10;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
