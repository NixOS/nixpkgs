{ lib
, fetchPypi
, buildPythonPackage
, boost-histogram
, histoprint
, hatchling
, hatch-vcs
, numpy
, pytestCheckHook
, pytest-mpl
}:

buildPythonPackage rec {
  pname = "hist";
  version = "2.6.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dede097733d50b273af9f67386e6dcccaab77e900ae702e1a9408a856e217ce9";
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    boost-histogram
    histoprint
    numpy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mpl
  ];

  meta = with lib; {
    description = "Histogramming for analysis powered by boost-histogram";
    homepage = "https://hist.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
