{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pynvim,
  setuptools,
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "unstable-2024-03-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "34e3a027c595981886d7efd1c91071f3eaa4715d";
    hash = "sha256-2+jDRJXlg9q4MN9vOhmeq4cWVJ0wp5r5xAh3G8lqgOg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pynvim ];

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/pynvim_pp";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
