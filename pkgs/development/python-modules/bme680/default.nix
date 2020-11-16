{ lib
, buildPythonPackage
, fetchFromGitHub
, smbus-cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bme680";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "pimoroni";
    repo = "bme680-python";
    rev = "v${version}";
    sha256 = "sha256-oIXh1JnGTI/Cj4MQFpWq+sWR2X+ioCsK0Q+T7wPITCQ=";
  };

  propagatedBuildInputs = [ smbus-cffi ];

  preBuild = ''
    cd library
  '';
  checkInputs = [ pytestCheckHook ];

  # next release will have tests, but not the current one
  doCheck = false;

  pythonImportsCheck = [ "bme680" ];

  meta = with lib; {
    description = "Python library for driving the Pimoroni BME680 Breakout";
    homepage = "https://github.com/pimoroni/bme680-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
