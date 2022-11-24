{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, cython
}:

buildPythonPackage rec {
  pname = "fastbencode";
  version = "0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wal451pQSLuoM9kNbnSKVZUMqLWfEukXwqLI58p+tvU=";
  };

  nativeBuildInputs = [
    cython
  ];

  pythonImportsCheck = [
    "fastbencode"
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest fastbencode.tests.test_suite
  '';

  meta = with lib; {
    description = "Fast implementation of bencode";
    homepage = "https://github.com/breezy-team/fastbencode";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marsam ];
  };
}
