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

buildPythonPackage rec {
  pname = "leidenalg";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vtraag";
    repo = "leidenalg";
    tag = version;
    hash = "sha256-u4xW1gsWDpbsFVLlOIiPZtpw9t4iFBC7fzwn04flev8=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [
    igraph-c
    libleidenalg
  ];

  propagatedBuildInputs = [ igraph ];

  nativeCheckInputs = [
    ddt
    unittestCheckHook
  ];

  pythonImportsCheck = [ "leidenalg" ];

  meta = {
    changelog = "https://github.com/vtraag/leidenalg/blob/${src.tag}/CHANGELOG";
    description = "Implementation of the Leiden algorithm for various quality functions to be used with igraph in Python";
    homepage = "https://github.com/vtraag/leidenalg";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
