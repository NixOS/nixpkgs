{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pythonImportsCheckHook,
  pytestCheckHook,
  setuptools,
  click,
  html5lib,
  jinja2,
  markdown,
  freezegun,
  pytest-mock,
}:
buildPythonApplication (finalAttrs: {
  pname = "mailmerge";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "awdeorio";
    repo = "mailmerge";
    tag = finalAttrs.version;
    hash = "sha256-gSfO61AwM4C1nOOA2C5pboeN4Wpjk8aJhx7sjSBqd8A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    html5lib
    jinja2
    markdown
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin"
  '';

  nativeCheckInputs = [
    pythonImportsCheckHook
    pytestCheckHook
    freezegun
    pytest-mock
  ];

  pythonImportsCheck = [
    "mailmerge"
  ];

  meta = {
    description = "Command line mail merge tool";
    homepage = "https://github.com/awdeorio/mailmerge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniellaing ];
  };
})
