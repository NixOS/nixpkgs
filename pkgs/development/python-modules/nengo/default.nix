{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  numpy,
  scipySupport ? false,
  scipy,
  scikitSupport ? false,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "nengo";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo";
    tag = "v${version}";
    hash = "sha256-yZDnttXU5qMmQwFESkhQb06BXcqPEiPYl54azS5b284=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      numpy
    ]
    ++ lib.optionals scipySupport [ scipy ]
    ++ lib.optionals scikitSupport [ scikit-learn ];

  # checks req missing:
  #   pytest-allclose
  #   pytest-rng
  doCheck = false;

  pythonImportsCheck = [ "nengo" ];

  meta = with lib; {
    description = "Python library for creating and simulating large-scale brain models";
    homepage = "https://nengo.ai/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ arjix ];
  };
}
