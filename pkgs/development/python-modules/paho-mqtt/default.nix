{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, stdenv, pytestrunner, pytest, mock }:

buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "1.4.0";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    sha256 = "1xg9ppz2lqacd9prsrx93q2wfkjjyla03xlfw74aj1alz9ki5hrs";
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
