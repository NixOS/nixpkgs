{
  lib,
  fetchPypi,
  buildPythonPackage,
  tkinter,
}:

buildPythonPackage rec {
  pname = "pymsgbox";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyMsgBox";
    inherit version;
    hash = "sha256-mNBVxJpRHcwQ+gjDBD5xAtRo9eSzqDxtPGHfcix9eY0=";
  };

  propagatedBuildInputs = [ tkinter ];

  # Finding tests fails
  doCheck = false;
  pythonImportsCheck = [ "pymsgbox" ];

  meta = {
    description = "Simple, cross-platform, pure Python module for JavaScript-like message boxes";
    homepage = "https://github.com/asweigart/PyMsgBox";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
