{ lib
, buildPythonPackage
, fetchFromGitHub
, pynvim
, setuptools
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "unstable-2023-08-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "40d0f6053ddbba61f53505eebb0290cfb661661b";
    hash = "sha256-4jeYE9HL+PQZuJq5nyf9CgL4UrRWm3ifLL/vfygLOwc=";
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
