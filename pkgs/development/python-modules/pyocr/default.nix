{ lib
, fetchFromGitLab
, buildPythonPackage
, pillow
, setuptools-scm
, setuptools-scm-git-archive
, tesseract
, cuneiform
, isPy3k
, substituteAll
, pytestCheckHook
, tox
}:

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

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cuneiform tesseract;
    })
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [ setuptools-scm setuptools-scm-git-archive ];

  propagatedBuildInputs = [ pillow ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Python wrapper for Tesseract and Cuneiform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
