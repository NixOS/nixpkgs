{ stdenv, buildPythonPackage, fetchPypi, pytest, cffi }:

buildPythonPackage rec {
  pname = "atomiclong";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gjbc9lvpkgg8vj7dspif1gz9aq4flkhxia16qj6yvb7rp27h4yb";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ cffi ];

  meta = with stdenv.lib; {
    description = "Long data type with atomic operations using CFFI";
    homepage = https://github.com/dreid/atomiclong;
    license = licenses.mit;
    maintainers = with maintainers; [ robbinch ];
  };
}
