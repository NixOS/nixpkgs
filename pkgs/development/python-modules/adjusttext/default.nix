{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, packaging
, pythonOlder
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "adjusttext";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Phlya";
    repo = "adjusttext";
    rev = "refs/tags/v${version}";
    hash = "sha256-o/TA/br7sJAcvfIR4uA7a6XRf/enJ/x7N4ys6Of0j3g=";
  };

  nativeBuildInputs = [
    packaging
    setuptools
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "adjustText"
  ];

  meta = with lib; {
    description = "Iteratively adjust text position in matplotlib plots to minimize overlaps";
    homepage = "https://github.com/Phlya/adjustText";
    changelog = "https://github.com/Phlya/adjustText/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
