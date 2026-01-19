{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  jinja2,
  lib,
  markdown,
  pygments,
  pymdown-extensions,
  pytest-cov-stub,
  pytestCheckHook,
  python-frontmatter,
  weasyprint,
}:

buildPythonPackage rec {
  pname = "md2pdf";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmaupetit";
    repo = "md2pdf";
    tag = "v${version}";
    hash = "sha256-Do4GW3Z1LmcFSOSCQ0ESztJSrtaNp+2gfci2tDH3+E8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    jinja2
    markdown
    pygments
    pymdown-extensions
    python-frontmatter
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
    changelog = "https://github.com/jmaupetit/md2pdf/blob/${src.tag}/CHANGELOG.md";
    description = "Markdown to PDF conversion tool";
    homepage = "https://github.com/jmaupetit/md2pdf";
    license = lib.licenses.mit;
    mainProgram = "md2pdf";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
