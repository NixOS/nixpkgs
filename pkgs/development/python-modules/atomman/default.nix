{ stdenv
, buildPythonPackage
, fetchPypi
, xmltodict
, datamodeldict
, numpy
, matplotlib
, scipy
, pandas
, cython
, numericalunits
, pytest
}:

buildPythonPackage rec {
  version = "1.2.8";
  pname = "atomman";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ed099fdceca2d733e81afb08d777e8e852a6e53660d6d268f3739b8d323ced9";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ xmltodict datamodeldict numpy matplotlib scipy pandas cython numericalunits ];

  # tests not included with Pypi release
  doCheck = false;

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/usnistgov/atomman/;
    description = "Atomistic Manipulation Toolkit";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
