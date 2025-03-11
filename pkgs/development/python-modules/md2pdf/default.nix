{
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  lib,
  markdown2,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  weasyprint,
}:

buildPythonPackage rec {
  pname = "md2pdf";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmaupetit";
    repo = "md2pdf";
    tag = version;
    hash = "sha256-9B1vVfcBHk+xdE2Xouu95j3Hp4xm9d5DgPv2zKwCvHY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    docopt
    markdown2
    weasyprint
  ];

  pythonImportsCheck = [ "md2pdf" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  meta = {
    changelog = "https://github.com/jmaupetit/md2pdf/blob/${src.rev}/CHANGELOG.md";
    description = "Markdown to PDF conversion tool";
    homepage = "https://github.com/jmaupetit/md2pdf";
    license = lib.licenses.mit;
    mainProgram = "md2pdf";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
