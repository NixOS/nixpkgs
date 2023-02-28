{ lib
, fetchFromGitLab
, buildPythonPackage
, pillow
, tesseract
, cuneiform
, isPy3k
, substituteAll
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyocr";
  version = "0.8.3";
  disabled = !isPy3k;

  # Don't fetch from PYPI because it doesn't contain tests.
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "pyocr";
    rev = version;
    sha256 = "sha256-gIn50H9liQcTb7SzoWnBwm5LTvkr+R+5OPvITls1B/w=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cuneiform tesseract;
    })
  ];

  # see the logic in setup.py
  ENABLE_SETUPTOOLS_SCM = "0";
  preConfigure = ''
    echo 'version = "${version}"' > src/pyocr/_version.py
  '';

  propagatedBuildInputs = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Python wrapper for Tesseract and Cuneiform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ symphorien ];
  };
}
