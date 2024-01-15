{ lib
, buildPythonPackage
, fetchFromGitHub

, setuptools

, defusedxml
, pillow
, fonttools

, pytestCheckHook
, qrcode
, camelot
, uharfbuzz
}:

buildPythonPackage rec {
  pname = "fpdf2";
  version = "2.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "fpdf2";
    rev = version;
    hash = "sha256-wiCKmS+GlrYV2/6TEdXUbmWIMWU4hyzswFJZR9EOWxc=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=fpdf --cov-report=xml" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    defusedxml
    pillow
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    qrcode
    camelot
    uharfbuzz
  ];

  disabledTestPaths = [
    "test/table/test_table_extraction.py" # tabula-py not packaged yet
    "test/signing/test_sign.py" # endesive not packaged yet
  ];

  disabledTests = [
    "test_png_url" # tries to download file
    "test_page_background" # tries to download file
    "test_share_images_cache" # uses timing functions
  ];

  meta = {
    homepage = "https://github.com/py-pdf/fpdf2";
    description = "Simple PDF generation for Python";
    changelog = "https://github.com/py-pdf/fpdf2/blob/${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jfvillablanca ];
  };
}
