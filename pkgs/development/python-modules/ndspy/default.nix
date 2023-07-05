{ lib
, buildPythonPackage
, fetchFromGitHub
, crcmod
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ndspy";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RoadrunnerWMC";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x3sp10had1mq192m7kgjivvs8kpjagxjgj9d4z95dfjhzzbjh70";
  };

  propagatedBuildInputs = [
    crcmod
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ndspy"
  ];

  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Python library for many Nintendo DS file formats";
    homepage = "https://github.com/RoadrunnerWMC/ndspy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
