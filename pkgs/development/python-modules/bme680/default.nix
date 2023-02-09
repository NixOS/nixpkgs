{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, smbus-cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bme680";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "pimoroni";
    repo = "bme680-python";
    rev = "v${version}";
    sha256 = "sha256-gmdRxMJ0DoCyNcb/bYp746PBi4HktHAAYOcSQJ0Uheg=";
  };

  propagatedBuildInputs = [
    smbus-cffi
  ];

  preBuild = ''
    cd library
  '';

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace library/setup.cfg \
      --replace "smbus" "smbus-cffi"
  '';

  pythonImportsCheck = [ "bme680" ];

  meta = with lib; {
    description = "Python library for driving the Pimoroni BME680 Breakout";
    homepage = "https://github.com/pimoroni/bme680-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
  };
}
