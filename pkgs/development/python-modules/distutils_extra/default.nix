{ lib
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "distutils-extra";
  version = "2.45";

  src = fetchurl {
    url = "https://salsa.debian.org/python-team/modules/python-distutils-extra/-/archive/${version}/python-${pname}-${version}.tar.bz2";
    sha256 = "1aifizd4nkvdnkwdna7i6xgjcqi1cf228bg8kmnwz67f5rflk3z8";
  };

  # Tests are out-dated as the last upstream release is from 2016
  doCheck = false;

  pythonImportsCheck = [ "DistUtilsExtra" ];

  meta = with lib; {
    description = "Enhancements to Python's distutils";
    homepage = "https://launchpad.net/python-distutils-extra";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
