{ buildPythonPackage
, lib
, isPyPy
, isPy27
, fetchFromGitHub
, pylama
, pytest
, pytestrunner
, mock
}:
buildPythonPackage rec {
  name = "paho-mqtt-${version}";
  version = "1.4.0";

  disabled = isPyPy;

  # fetch from GitHub so we can run the tests
  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    sha256 = "1xg9ppz2lqacd9prsrx93q2wfkjjyla03xlfw74aj1alz9ki5hrs";
  };

  buildInputs = [ pylama ];
  checkInputs = [ pytest pytestrunner ] ++ lib.optional isPy27 mock;

  meta = with lib; {
    homepage = "https://eclipse.org/paho/";
    description = "mqtt library for machine to machine and internet of things";
    license = licenses.epl10;
    maintainers = with maintainers; [ mog ];
  };
}
