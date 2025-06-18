{
  lib,
  fetchPypi,
  buildPythonPackage,
  tkinter,
}:

buildPythonPackage rec {
  pname = "pymsgbox";
  version = "1.0.9";

  src = fetchPypi {
    pname = "PyMsgBox";
    inherit version;
    hash = "sha256-IZQifei/96PW2lQYSHBaFV3LsqBu4SDZ8oCh1/USY/8=";
  };

  propagatedBuildInputs = [ tkinter ];

  # Finding tests fails
  doCheck = false;
  pythonImportsCheck = [ "pymsgbox" ];

  meta = with lib; {
    description = "Simple, cross-platform, pure Python module for JavaScript-like message boxes";
    homepage = "https://github.com/asweigart/PyMsgBox";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
