{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "metar";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
    rev = "v${version}";
    sha256 = "sha256-pl2NWRfFCYyM2qvBt4Ic3wgbGkYZvAO6pX2Set8zYW8=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "metar" ];

  meta = with lib; {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
    license = with licenses; [ bsd1 ];
    maintainers = with maintainers; [ fab ];
  };
}
