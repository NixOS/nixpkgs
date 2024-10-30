{
  lib,
  buildPythonPackage,
  fetchPypi,
  installShellFiles,
  setuptools,
  setuptools-scm,
  wheel,
  docutils,
  importlib-metadata,
  jinja2,
  packaging,
  pygments,
  pyyaml,
  reportlab,
  smartypants,
  pillow,
  pytestCheckHook,
  pymupdf,
  sphinx,
}:

buildPythonPackage rec {
  pname = "rst2pdf";
  version = "0.102";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NzAGJOlTpz7d3cuubyRjDvVGfCC+61jfZIrcUwhE9CU=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    installShellFiles
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    docutils
    importlib-metadata
    jinja2
    packaging
    pygments
    pyyaml
    reportlab
    smartypants
    pillow
  ];

  pythonImportsCheck = [ "rst2pdf" ];

  nativeCheckInputs = [
    pytestCheckHook
    pymupdf
    sphinx
  ];

  # Test suite fails: https://github.com/rst2pdf/rst2pdf/issues/1067
  doCheck = false;

  postInstall = ''
    ${lib.getExe' docutils "rst2man"} doc/rst2pdf.rst rst2pdf.1
    installManPage rst2pdf.1
  '';

  meta = with lib; {
    description = "Convert reStructured Text to PDF via ReportLab";
    mainProgram = "rst2pdf";
    homepage = "https://rst2pdf.org/";
    changelog = "https://github.com/rst2pdf/rst2pdf/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ pyrox0 ];
  };
}
