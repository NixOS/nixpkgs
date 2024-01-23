{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, numpy
, scipySupport ? false, scipy
, scikitSupport ? false, scikit-learn
}:

buildPythonPackage rec {
  pname = "nengo";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-b9mPjKdewIqIeRrddV1/M3bghSyox7Lz6VbfSLCHZjA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ numpy ]
    ++ lib.optionals scipySupport [ scipy ]
    ++ lib.optionals scikitSupport [ scikit-learn ];

  # checks req missing:
  #   pytest-allclose
  #   pytest-plt
  #   pytest-rng
  doCheck = false;

  pythonImportsCheck = [ "nengo" ];

  meta = with lib; {
    description = "A Python library for creating and simulating large-scale brain models";
    homepage    = "https://nengo.ai/";
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ arjix ];
  };
}
