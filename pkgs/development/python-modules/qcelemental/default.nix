{ buildPythonPackage, lib, fetchPypi, numpy
, pydantic, pint,  networkx, pytest-runner, pytest-cov, pytest
} :

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.23.0";

  checkInputs = [ pytest-runner pytest-cov pytest ];
  propagatedBuildInputs = [ numpy pydantic pint networkx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "642bc86ce937621ddfb1291cbff0851be16b26feb5eec562296999e36181cee3";
  };

  doCheck = true;

  meta = with lib; {
    description = "Periodic table, physical constants, and molecule parsing for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/en/latest/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
