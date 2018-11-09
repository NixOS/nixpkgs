{ stdenv
, buildPythonPackage
, fetchPypi
, six
, numpy
, scipy
, asteval
, uncertainties
, pytest
, nose
}:

buildPythonPackage rec {
  pname = "lmfit";
  version = "0.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f635c69fa67cd4d3daa1148f449abc2ff1e19adf5761b3eac7d314224d7506e2";
  };

  checkInputs = [ pytest nose ];
  propagatedBuildInputs = [ six numpy scipy asteval uncertainties ];

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    description = "Least-Squares Minimization with Bounds and Constraints";
    homepage = https://lmfit.github.io/lmfit-py/;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
