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
  version = "1.2.3";
  pname = "atomman";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9eb6acc5497263cfa89be8d0f383a9a69f0726b4ac6798c1b1d96f26705ec09c";
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
