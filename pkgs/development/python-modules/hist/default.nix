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
  version = "2.7.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/74xTCvQPDQrnxaNznFa2PNigesjFyoAlwiCqTRP6Yg=";
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
