{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, pythonOlder
<<<<<<< HEAD
=======
, importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, jbig2dec
, deprecation
, lxml
, mupdf
, packaging
, pillow
, psutil
, pybind11
, pytest-xdist
, pytestCheckHook
, python-dateutil
, python-xmp-toolkit
, qpdf
, setuptools
<<<<<<< HEAD
=======
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, substituteAll
, wheel
}:

buildPythonPackage rec {
  pname = "pikepdf";
<<<<<<< HEAD
  version = "8.3.0";
=======
  version = "7.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pikepdf";
    repo = "pikepdf";
    rev = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
<<<<<<< HEAD
    hash = "sha256-d76s4iJFwhzWSySXTS53PQQuWfWIboIRecEyjzobsME=";
=======
    hash = "sha256-acGIhIWC1nUQiN0iwb1kLKxz+ytIqYIW4VXF45Tx50g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      jbig2dec = "${lib.getBin jbig2dec}/bin/jbig2dec";
      mudraw = "${lib.getBin mupdf}/bin/mudraw";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "shims_enabled = not cflags_defined" "shims_enabled = False"
  '';

<<<<<<< HEAD
=======
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    qpdf
  ];

  nativeBuildInputs = [
    pybind11
    setuptools
<<<<<<< HEAD
=======
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wheel
  ];

  nativeCheckInputs = [
    attrs
    hypothesis
    pytest-xdist
    psutil
    pytestCheckHook
    python-dateutil
    python-xmp-toolkit
  ];

  propagatedBuildInputs = [
    deprecation
    lxml
    packaging
    pillow
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "pikepdf" ];

  meta = with lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kiwi dotlambda ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${src.rev}/docs/releasenotes/version${lib.versions.major version}.rst";
  };
}
