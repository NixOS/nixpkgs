{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f75240520c918793510766d8b1f5ebc1feb0286f86eab971550f6580b0ea68f5";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Python package for controlling Neato pybotvac Connected vacuum robot";
    homepage = https://github.com/stianaske/pybotvac;
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
