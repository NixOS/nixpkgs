{ stdenv, fetchPypi, buildPythonPackage, colorama }:

buildPythonPackage rec {
  pname = "crayons";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50e5fa729d313e2c607ae8bf7b53bb487652e10bd8e7a1e08c4bc8bf62755ffc";
  };

  propagatedBuildInputs = [ colorama ];

  meta = with stdenv.lib; {
    description = "TextUI colors for Python";
    homepage = https://github.com/kennethreitz/crayons;
    license = licenses.mit;
  };
}
