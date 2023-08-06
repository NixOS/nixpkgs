{ lib
, buildPythonPackage
, fetchFromGitHub
, pynvim
, setuptools
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "unstable-2023-07-09";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "93aa25bf3ee039c4eb85f402d6adf6977033013b";
    hash = "sha256-gZvIiFpP+eMLD8/xodY7ywWxhWXtethXviVRedW/bgo=";
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
