{ lib, buildPythonPackage, fetchPypi
, six, nose, unittest2, mock }:

buildPythonPackage rec {
  pname = "case";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48432b01d91913451c3512c5b90e31b0f348f1074b166a3431085eb70d784fb1";
  };

  propagatedBuildInputs = [ six nose unittest2 mock ];

  meta = with lib; {
    homepage = "https://github.com/celery/case";
    description = "unittests utilities";
    license = licenses.bsd3;
  };
}
