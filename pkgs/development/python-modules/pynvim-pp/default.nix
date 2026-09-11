{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pynvim,
  setuptools,
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "0-unstable-2025-05-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "6beffc4f479360489481705dc23a9ebd54f0c17d";
    hash = "sha256-5QDqH+oOx7mANxTseszr7+kXCdu+vUWqwTgXxE2GhnA=";
  };

  build-system = [ setuptools ];

  dependencies = [ pynvim ];

  pythonImportsCheck = [ "pynvim_pp" ];

  meta = {
    homepage = "https://github.com/ms-jpq/pynvim_pp";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
