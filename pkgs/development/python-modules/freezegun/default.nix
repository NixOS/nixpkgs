{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, python-dateutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "1.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "177f9dd59861d871e27a484c3332f35a6e3f5d14626f2bf91be37891f18927f3";
  };

  propagatedBuildInputs = [ python-dateutil ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
