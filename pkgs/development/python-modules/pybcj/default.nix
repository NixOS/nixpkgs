{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i2gu0Iyqv7fAQtS+CD4o3caSr7He/1VnER+IVQcbdcM=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    setuptools-scm
  ];

  meta = with lib; {
    description = "python bindings with BCJ implementation by C language";
    license = licenses.lgpl2Plus;
  };
}

