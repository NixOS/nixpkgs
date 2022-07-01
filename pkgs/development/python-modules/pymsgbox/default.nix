{ lib, fetchPypi, buildPythonPackage, tkinter }:

buildPythonPackage rec {
  pname = "PyMsgBox";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IZQifei/96PW2lQYSHBaFV3LsqBu4SDZ8oCh1/USY/8=";
  };

  propagatedBuildInputs = [ tkinter ];

  # Finding tests fails
  doCheck = false;
  pythonImportsCheck = [ "pymsgbox" ];

  meta = with lib; {
    description = "A simple, cross-platform, pure Python module for JavaScript-like message boxes";
    homepage = "https://github.com/asweigart/PyMsgBox";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
