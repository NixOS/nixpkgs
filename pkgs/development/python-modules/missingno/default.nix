{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, scipy
, seaborn
, pytest
}:

buildPythonPackage rec {
  pname = "missingno";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ResidentMario";
    repo = pname;
    rev = version;
    sha256 = "0wxhj7qm2fcaiprdjfrx9p8nikc10qhivf7rzwi04r6mrzyi0i9x";
  };

  propagatedBuildInputs = [
    matplotlib
    scipy
    seaborn
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
  pytest tests/util_tests.py -k 'not cutoff'
  '';

  meta = with lib; {
    description = "Missing data visualization module for Python.";
    homepage = https://github.com/ResidentMario/missingno;
    maintainers = with maintainers; [ melsigl ];
    license = licenses.mit;
  };
}
