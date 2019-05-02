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
  version = "1.2.6";
  pname = "atomman";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19501bfdf7e66090764a0ccbecf85a128b46333ea232c2137fa4345512b8b502";
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
