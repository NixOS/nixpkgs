{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,

  # build system
  setuptools,

  # dependencies
  chardet,
  click,
  numpy,
  opencv-python-headless,
  openpyxl,
  pandas,
  pdfminer-six,
  pillow,
  pypdf,
  pypdfium2,
  tabulate,

  # tests
  pytestCheckHook,
  matplotlib,
}:
buildPythonPackage (finalAttrs: {
  pname = "camelot-py";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "camelot-dev";
    repo = "camelot";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-msf49Vt0IlwUNTvLIqTWKlMfcFB0LnvGGf7vReqhJec=";
  };

  patches = [ ./ghostscript.patch ];

  postPatch = ''
    substituteInPlace camelot/backends/ghostscript_backend.py \
      --replace-fail '@ghostscript@' ${lib.getExe pkgs.ghostscript_headless}
  '';

  pythonRelaxDeps = [ "pypdf" ];

  build-system = [ setuptools ];

  dependencies = [
    click
    numpy
    opencv-python-headless
    openpyxl
    pandas
    pdfminer-six
    pillow
    pypdf
    pypdfium2
    tabulate
    # Dependency not present in project's pyproject.toml, but doesn't build without it
    chardet
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
  ];
  disabledTests = [
    # Assertion Error: <Cell cords> != <Cell other_cords>
    "test_repr_ghostscript"
    # cv2.error: color.cpp failure
    "test_repr_ghostscript_custom_backend"
    # urllib.error.URLError: temporary failure in name
    "test_url_pdfium"
    "test_url_ghostscript"
    "test_url_ghost_script_custom_backend"
    "test_pages_pdfium"
    "test_pages_ghostscript"
    "test_pages_ghostscript_custom_backend"
  ];

  pythonImportsCheck = [ "camelot" ];

  meta = {
    description = "Python library to extract tabular data from PDFs";
    mainProgram = "camelot";
    homepage = "http://camelot-py.readthedocs.io";
    changelog = "https://github.com/camelot-dev/camelot/blob/${finalAttrs.src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _2gn ];
  };
})
