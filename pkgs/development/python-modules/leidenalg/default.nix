{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  igraph,
  igraph-c,
  libleidenalg,
  pythonOlder,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "leidenalg";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vtraag";
    repo = "leidenalg";
    tag = version;
    hash = "sha256-oaTV+BIB/YQBWKrVXuiIEMH/1MxPxeHhjUzbmxt6hlw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    igraph-c
    libleidenalg
  ];

  propagatedBuildInputs = [ igraph ];

  checkInputs = [
    ddt
    unittestCheckHook
  ];

  pythonImportsCheck = [ "leidenalg" ];

  meta = with lib; {
    changelog = "https://github.com/vtraag/leidenalg/blob/${version}/CHANGELOG";
    description = "Implementation of the Leiden algorithm for various quality functions to be used with igraph in Python";
    homepage = "https://github.com/vtraag/leidenalg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jboy ];
  };
}
