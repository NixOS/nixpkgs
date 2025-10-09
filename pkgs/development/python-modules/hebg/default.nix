{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # Runtime dependencies
  networkx,
  matplotlib,
  numpy,
  tqdm,
  scipy,

  # Build, dev and test dependencies
  setuptools-scm,
  pytestCheckHook,
  pytest-check,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "hebg";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-11bz+FbnaEVLiXT1eujMw8lvABlzVOeROOsdVgsyfjQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    networkx
    matplotlib
    numpy
    tqdm
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-check
    pytest-mock
  ];
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { MPLBACKEND = "Agg"; };
  pythonImportsCheck = [ "hebg" ];

  meta = {
    description = "Hierachical Explainable Behaviors using Graphs";
    homepage = "https://github.com/IRLL/HEB_graphs";
    changelog = "https://github.com/IRLL/HEB_graphs/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ automathis ];
  };
}
