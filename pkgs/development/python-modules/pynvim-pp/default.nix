{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pynvim,
  setuptools,
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "0-unstable-2025-02-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "781f6beda5f5966857792af040d5e2ecff5467e4";
    hash = "sha256-ggZqlaCP9WNECO+eRwi968EvQb8zuHCic6+9Zngsd24=";
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
