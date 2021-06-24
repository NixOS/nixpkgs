{ lib
, buildPythonPackage
, certifi
, fetchPypi
, flaky
, pytestCheckHook
, pythonOlder
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "4.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w/mkAUUgj7L7Xv+nz1pI1TYKfihH3S3MbxaNQ4VtoH0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    certifi
    six
  ];

  checkInputs = [
    pytestCheckHook
    flaky
  ];

  pythonImportsCheck = [ "pylast" ];

  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
