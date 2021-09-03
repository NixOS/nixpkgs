{ buildPythonPackage, lib, fetchPypi, numpy
, pydantic, pint,  networkx, pytest-runner, pytest-cov, pytest
} :

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.22.0";

  checkInputs = [ pytest-runner pytest-cov pytest ];
  propagatedBuildInputs = [ numpy pydantic pint networkx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d7fc613fbe30189cfa970a863a5955865b1116ff651d20325c721b6f0ef1f52";
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
