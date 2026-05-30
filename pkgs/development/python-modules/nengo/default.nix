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

buildPythonPackage (finalAttrs: {
  pname = "nengo";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nengo";
    repo = "nengo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yZDnttXU5qMmQwFESkhQb06BXcqPEiPYl54azS5b284=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
  ]
  ++ lib.optionals scipySupport [ scipy ]
  ++ lib.optionals scikitSupport [ scikit-learn ];

  # checks req missing:
  #   pytest-allclose
  #   pytest-plt
  #   pytest-rng
  doCheck = false;

  pythonImportsCheck = [ "nengo" ];

  meta = {
    description = "Python library for creating and simulating large-scale brain models";
    homepage = "https://nengo.ai/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
