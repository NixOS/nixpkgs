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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hist";
  version = "2.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JrGrgQ2LECIttdFh1KyvZKqgT+a6rtKWbUHB2sVgHQY=";
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
    homepage = "https://hist.readthedocs.io/";
    changelog = "https://github.com/scikit-hep/hist/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
