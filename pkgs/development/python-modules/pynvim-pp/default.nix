{ lib
, buildPythonPackage
, fetchFromGitHub
, pynvim
, setuptools
}:

buildPythonPackage {
  pname = "pynvim-pp";
  version = "unstable-2023-07-05";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "pynvim_pp";
    rev = "e9ac3171c7edcc0be020d63840d6af4222b69540";
    hash = "sha256-H1sCwU2wl9HO92LNkvkCb1iLbZrTNMmYA/8qy9uCgyU=";
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
