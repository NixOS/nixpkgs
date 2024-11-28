{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pynvim,
  setuptools,
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "unstable-2024-07-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "6d3c298b7eb9543bce7ab515b0a39f256c1d37ca";
    hash = "sha256-W6YaxI/fa2HL6+FIBTTA+7K2Be02iuIfFFVO/hhYnpo=";
  };

  build-system = [ setuptools ];

  dependencies = [ pynvim ];

  meta = {
    homepage = "https://github.com/ms-jpq/pynvim_pp";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
