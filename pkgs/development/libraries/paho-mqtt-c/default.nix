{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.c";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.c";
    rev = "v${version}";
    hash = "sha256-TGCWA9tOOx0rCb/XQWqLFbXb9gOyGS8u6o9fvSRS6xI=";
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
