{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6f147694ee5cbab1dea494454c11bd254e1c214d96d057cba27894a87210f1b";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Python package for controlling Neato pybotvac Connected vacuum robot";
    homepage = https://github.com/stianaske/pybotvac;
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
