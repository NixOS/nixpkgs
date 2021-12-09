{ lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchpatch
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

  patches = lib.optionals (pythonAtLeast "3.10") [
    # Staticmethods in 3.10+ are now callable, prevent freezegun to attempt to decorate them
    (fetchpatch {
      url = "https://github.com/spulec/freezegun/pull/397/commits/e63874ce75a74a1159390914045fe8e7955b24c4.patch";
      sha256 = "sha256-FNABqVN5DFqVUR88lYzwbfsZj3xcB9/MvQtm+I2VjnI=";
    })
  ];

  propagatedBuildInputs = [ python-dateutil ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
