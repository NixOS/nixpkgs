{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  igraph,
  igraph-c,
  libleidenalg,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "leidenalg";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vtraag";
    repo = "leidenalg";
    tag = finalAttrs.version;
    hash = "sha256-E8mFzEVzff3BEt5sPDXy8/ofZgVfzgiUyIqT59/Trd0=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [
    igraph-c
    libleidenalg
  ];

  dependencies = [ igraph ];

  nativeCheckInputs = [
    ddt
    unittestCheckHook
  ];

  pythonImportsCheck = [ "leidenalg" ];

  meta = {
    changelog = "https://github.com/vtraag/leidenalg/blob/${finalAttrs.src.tag}/CHANGELOG";
    description = "Implementation of the Leiden algorithm for various quality functions to be used with igraph in Python";
    homepage = "https://github.com/vtraag/leidenalg";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jboy ];
  };
})
