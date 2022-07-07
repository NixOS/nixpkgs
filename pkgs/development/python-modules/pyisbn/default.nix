{ buildPythonPackage
, fetchPypi
, hypothesis
, pythonOlder
, pytestCheckHook
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "pyisbn";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06fm9rn31cb4b61hzy63cnwfjpppgyy517k8a04gzcv9g60n7xbh";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov pyisbn --cov-report term-missing --no-cov-on-fail" ""
  '';

  checkInputs = [ pytestCheckHook hypothesis ];

  pythonImportsCheck = [ "pyisbn" ];

  meta = with lib; {
    license = licenses.gpl3Plus;
    homepage = "https://github.com/JNRowe/pyisbn";
    description = "Python module for working with 10- and 13-digit ISBNs";
    maintainers = with maintainers; [ eigengrau ];
  };
}
