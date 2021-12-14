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
  version = "4.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da6ebea506019af571941c35c8b4802abde4679592d52d13675650dc447e6c29";
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
