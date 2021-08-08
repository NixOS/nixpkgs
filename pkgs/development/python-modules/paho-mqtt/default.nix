{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, stdenv, pytest-runner, pytest, mock }:

buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "1.5.1";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    sha256 = "1y537i6zxkjkmi80w5rvd18npz1jm5246i2x8p3q7ycx94i8ixs0";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "pylama" ""
    substituteInPlace setup.cfg --replace "--pylama" ""
  '';

  checkInputs = [ pytest-runner pytest ] ++ lib.optional (!isPy3k) mock;

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://eclipse.org/paho";
    description = "MQTT version 3.1.1 client class";
    license = licenses.epl10;
    maintainers = with maintainers; [ mog dotlambda ];
  };
}
