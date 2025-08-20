{
  lib,
  buildPythonPackage,
  numpy,
  pkgs,
  pybind11,
}:

buildPythonPackage rec {
  inherit (pkgs.fasttext) pname version src;

  format = "setuptools";

  buildInputs = [ pybind11 ];

  pythonImportsCheck = [ "fasttext" ];

  propagatedBuildInputs = [ numpy ];

  preBuild = ''
    HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Python module for text classification and representation learning";
    homepage = "https://fasttext.cc/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
