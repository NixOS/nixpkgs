{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "tocpdf";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kszenes";
    repo = "tocPDF";
    rev = "v${version}";
    hash = "sha256-RaNMhEgJ2pSL9BvK1d2Z8AsUPhARaRtEiCnt/2E2uNs=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    pdfplumber
    pypdf
    tika
    tqdm
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    # touches network
    "test_read_toc"
  ];

  pythonImportsCheck = [ "tocPDF" ];

  meta = {
    description = "Automatic CLI tool for generating outline of PDFs based on the table of contents";
    homepage = "https://github.com/kszenes/tocPDF";
    changelog = "https://github.com/kszenes/tocPDF/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dansbandit ];
    mainProgram = "tocPDF";
  };
}
