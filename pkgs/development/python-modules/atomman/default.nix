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
  version = "1.2.4";
  pname = "atomman";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c204d52cdfb2a7cc4d7d2c4f7a89c215a9fd63b92495a83adf25ae4e820cea3e";
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
