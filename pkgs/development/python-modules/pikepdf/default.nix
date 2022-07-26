{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, pythonOlder
, importlib-metadata
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
, setuptools-scm
, substituteAll
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "5.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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
    hash = "sha256-QYSI0oWuDw19EF8pwh3t1+VOY3Xe/AZxL1uARufg/nE=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      jbig2dec = "${lib.getBin jbig2dec}/bin/jbig2dec";
      mudraw = "${lib.getBin mupdf}/bin/mudraw";
    })
  ];

  postPatch = ''
    sed -i 's|\S*/opt/homebrew.*|pass|' setup.py

    substituteInPlace setup.py \
      --replace setuptools_scm_git_archive ""
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    pybind11
    qpdf
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
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
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
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
