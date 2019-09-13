{ lib, buildPythonPackage, fetchPypi, click, psutil }:

buildPythonPackage rec {
  pname = "daemonocle";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s5b9llh3975ix60sxcgjiq0wr5sii4as5hqk8m31433bzaliz58";
  };

  propagatedBuildInputs = [ click psutil ];

  meta = with lib; {
    homepage = "http://github.com/jnrbsn/daemonocle";
    description = "A Python library for creating super fancy Unix daemons";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
