{
  lib,
  buildPythonPackage,
  numpy,
  pkgs,
  pybind11,
}:

buildPythonPackage {
  inherit (pkgs.fasttext) pname version src;

  format = "setuptools";

  buildInputs = [ pybind11 ];

  pythonImportsCheck = [ "fasttext" ];

  propagatedBuildInputs = [ numpy ];

  preBuild = ''
    HOME=$TMPDIR
  '';

<<<<<<< HEAD
  meta = {
    description = "Python module for text classification and representation learning";
    homepage = "https://fasttext.cc/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Python module for text classification and representation learning";
    homepage = "https://fasttext.cc/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
