{
  lib,
  fetchPypi,
  buildPythonPackage,
  tkinter,
}:

buildPythonPackage rec {
  pname = "pymsgbox";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyMsgBox";
    inherit version;
    hash = "sha256-IZQifei/96PW2lQYSHBaFV3LsqBu4SDZ8oCh1/USY/8=";
  };

  propagatedBuildInputs = [ tkinter ];

  # Finding tests fails
  doCheck = false;
  pythonImportsCheck = [ "pymsgbox" ];

<<<<<<< HEAD
  meta = {
    description = "Simple, cross-platform, pure Python module for JavaScript-like message boxes";
    homepage = "https://github.com/asweigart/PyMsgBox";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jluttine ];
=======
  meta = with lib; {
    description = "Simple, cross-platform, pure Python module for JavaScript-like message boxes";
    homepage = "https://github.com/asweigart/PyMsgBox";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
