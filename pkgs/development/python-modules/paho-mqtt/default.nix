{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, stdenv, pytestrunner, pytest, mock }:

buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "1.5.0";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    sha256 = "1fq5z53g2k18iiqnz5qq87vzjpppfza072nx0dwllmhimm2dskh5";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "pylama" ""
    substituteInPlace setup.cfg --replace "--pylama" ""
  '';

  checkInputs = [ pytestrunner pytest ] ++ lib.optional (!isPy3k) mock;

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = https://eclipse.org/paho;
    description = "MQTT version 3.1.1 client class";
    license = licenses.epl10;
    maintainers = with maintainers; [ mog dotlambda ];
  };
}
