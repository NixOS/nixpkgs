{ lib
, bitlist
, buildPythonPackage
, fetchPypi
, fountains
, parts
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-947DIkmg56mAegEgLKq8iqETWf2SCvtmeDZi5cxVSJA=";
  };

  propagatedBuildInputs = [
    bitlist
    fountains
    parts
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fe25519" ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
