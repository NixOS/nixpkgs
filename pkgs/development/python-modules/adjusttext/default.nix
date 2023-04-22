{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, packaging
}:

buildPythonPackage rec {
  pname = "adjusttext";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Phlya";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-N+eCDwK5E9zGKG7uruuhnpTlJeiXG2a15PKW0gJFAqw=";
  };

  nativeBuildInputs = [
    packaging
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "adjustText"
  ];

  meta = with lib; {
    description = "Iteratively adjust text position in matplotlib plots to minimize overlaps";
    homepage = "https://github.com/Phlya/adjustText";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
