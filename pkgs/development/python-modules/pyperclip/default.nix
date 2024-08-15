{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
}:

buildPythonPackage rec {
  version = "1.9.0";
  pname = "pyperclip";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t94BQt3IG/xcdQfuoZ2pILkiUrVIuWGGyvlKXiUn0xA=";
  };

  build-system = [ setuptools ];

  # https://github.com/asweigart/pyperclip/issues/263
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} tests/test_pyperclip.py
  '';

  pythonImportsCheck = [ "pyperclip" ];

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsd3;
    description = "Cross-platform clipboard module";
    maintainers = with maintainers; [ dotlambda ];
  };
}
