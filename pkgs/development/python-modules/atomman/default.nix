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
  version = "1.2.5";
  pname = "atomman";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10eca8c6fc890f2ee2e30f65178c618175529e9998be449e276f7c3d1dce0e95";
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
