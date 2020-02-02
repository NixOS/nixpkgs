{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "identify";
  version = "1.4.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q1k22n8w7mmab1vh2r3bsqbxkxbb2zka548rcnn2rd9yg8rxnca";
  };

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "File identification library for Python";
    homepage = https://github.com/chriskuehl/identify;
    license = licenses.mit;
  };
}
