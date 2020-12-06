{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e983c9ffc0734c2e5a7c2adf5d0d0dfe399d94157c590ef70fad765f882c341f";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Python package for controlling Neato pybotvac Connected vacuum robot";
    homepage = "https://github.com/stianaske/pybotvac";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
