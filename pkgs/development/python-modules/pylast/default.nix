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
  version = "4.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71fd876e3753009bd10ea55b3f8f7c5d68591ee18a4127d257fc4a418010aa5c";
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
