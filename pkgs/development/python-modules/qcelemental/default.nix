{ buildPythonPackage, lib, fetchPypi, numpy, pydantic, pint,
  networkx, pytestrunner, pytestcov, pytest
} :

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.20.0";

  checkInputs = [ pytestrunner pytestcov pytest ];
  propagatedBuildInputs = [ numpy pydantic pint networkx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "141vw36fmacj897q26kq2bl9l0d23lyqjfry6q46aa9087dcs7ni";
  };

  doCheck = true;

  meta = with lib; {
    description = "Periodic table, physical constants, and molecule parsing for quantum chemistry.";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/en/latest/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
