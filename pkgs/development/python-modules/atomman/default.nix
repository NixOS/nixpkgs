{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, cython
, datamodeldict
, matplotlib
, numericalunits
, numpy
, pandas
, pytest
, scipy
, toolz
, xmltodict
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "atomman";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo  = "atomman";
    rev = "v${version}";
    sha256 = "09pfykd96wmw00s3kgabghykjn8b4yjml4ybpi7kwy7ygdmzcx51";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ xmltodict datamodeldict numpy matplotlib scipy pandas cython numericalunits toolz ];

  checkPhase = ''
    py.test tests -k 'not test_atomic'
  '';

  meta = with lib; {
    homepage = "https://github.com/usnistgov/atomman/";
    description = "Atomistic Manipulation Toolkit";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
