{ lib
, fetchFromGitLab
, buildPythonPackage
, pillow
, tesseract
, cuneiform
, isPy3k
, substituteAll
, pytestCheckHook
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyocr";
  version = "0.8.5";
  disabled = !isPy3k;
  format = "pyproject";

  # Don't fetch from PYPI because it doesn't contain tests.
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "pyocr";
    rev = version;
    hash = "sha256-gE0+qbHCwpDdxXFY+4rjVU2FbUSfSVrvrVMcWUk+9FU=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cuneiform tesseract;
    })
  ];

  propagatedBuildInputs = [ pillow ];

  nativeBuildInputs = [ setuptools setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    changelog = "https://gitlab.gnome.org/World/OpenPaperwork/pyocr/-/blob/${version}/ChangeLog";
    description = "A Python wrapper for Tesseract and Cuneiform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ symphorien ];
  };
}
