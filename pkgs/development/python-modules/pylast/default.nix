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
  version = "4.2.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R1enQk6luuBiobMPDn5x1SXx7zUI/5c8dPtyWkmG/18=";
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
