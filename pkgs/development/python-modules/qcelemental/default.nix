{ buildPythonPackage, lib, fetchPypi, numpy
, pydantic, pint,  networkx, pytestrunner, pytestcov, pytest
} :

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.21.0";

  checkInputs = [ pytestrunner pytestcov pytest ];
  propagatedBuildInputs = [ numpy pydantic pint networkx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b3c78fxbpnddrm1fnbvv4x2840jcfjg2l5cb5w4p38vzksiv238";
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
