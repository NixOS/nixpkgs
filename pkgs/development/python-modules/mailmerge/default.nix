{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  click,
  html5lib,
  jinja2,
  markdown,
}:
buildPythonApplication (finalAttrs: {
  pname = "mailmerge";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "awdeorio";
    repo = "mailmerge";
    rev = finalAttrs.version;
    hash = "sha256-gSfO61AwM4C1nOOA2C5pboeN4Wpjk8aJhx7sjSBqd8A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    html5lib
    jinja2
    markdown
  ];

  meta = {
    description = "A simple, command line mail merge tool.";
    homepage = "https://github.com/awdeorio/mailmerge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniellaing ];
  };
})
