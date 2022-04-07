{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "paho.mqtt.c";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w0q74yzrj79br3c4pgbw7p0ixbrfb7w2rz1ch4w81gvmb66xd77";
  };

  buildInputs = [ openssl ];

  patches = [
    ./change_install_paths.patch
  ];

  preInstall = ''
    export DESTDIR=$out
    export LDCONFIG=echo

    mkdir -p $out/lib $out/bin
  '';

  meta = with lib; {
    description = "An Eclipse Paho C client library for MQTT for Windows, Linux and MacOS. API documentation: https://eclipse.github.io/paho.mqtt.c/";
    homepage = "https://github.com/eclipse/paho.mqtt.c";
    license = licenses.epl20;
    maintainers = with maintainers; [ tilcreator ];
  };
}
