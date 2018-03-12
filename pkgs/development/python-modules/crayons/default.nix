{ stdenv, fetchPypi, buildPythonPackage, colorama }:

buildPythonPackage rec {
  pname = "crayons";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17c0v0dkk8sn8kyyy2w7myxq9981glrbczh6h8sdcr750lb6j5sy";
  };

  propagatedBuildInputs = [ colorama ];

  meta = with stdenv.lib; {
    description = "TextUI colors for Python";
    homepage = https://github.com/kennethreitz/crayons;
    license = licenses.mit;
  };
}
