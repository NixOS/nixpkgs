{ lib, fetchFromGitLab, buildPythonPackage, pillow, setuptools_scm,
setuptools-scm-git-archive , tesseract, cuneiform, isPy3k, substituteAll,
pytest, tox }:

buildPythonPackage rec {
  pname = "pyocr";
  version = "0.7.2";
  disabled = !isPy3k;

  # Don't fetch from PYPI because it doesn't contain tests.
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "pyocr";
    rev = version;
    sha256 = "09ab86bmizpv94w3mdvdqkjyyvk1vafw3jqhkiw5xx7p180xn3il";
  };

  patches = [ (substituteAll {
    src = ./paths.patch;
    inherit cuneiform tesseract;
  })
  ];

  buildInputs = [ setuptools_scm setuptools-scm-git-archive ];
  propagatedBuildInputs = [ pillow ];
  checkInputs = [ pytest tox ];
  checkPhase = "pytest";

  meta = {
    inherit (src.meta) homepage;
    description = "A Python wrapper for Tesseract and Cuneiform";
    license = lib.licenses.gpl3Plus;
  };
}
