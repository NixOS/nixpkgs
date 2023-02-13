{ lib
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "distutils-extra";
  version = "2.47";
  format = "setuptools";

  src = fetchurl {
    url = "https://salsa.debian.org/python-team/modules/python-distutils-extra/-/archive/${version}/python-${pname}-${version}.tar.bz2";
    hash = "sha256-vIl50yDVt5AW5lteWYqhAPlu8ErroOOJ1N/sfE2fbBU=";
  };

  # Tests are out-dated as the last upstream release is from 2016
  doCheck = false;

  pythonImportsCheck = [
    "DistUtilsExtra"
  ];

  meta = with lib; {
    description = "Enhancements to Python's distutils";
    homepage = "https://launchpad.net/python-distutils-extra";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
