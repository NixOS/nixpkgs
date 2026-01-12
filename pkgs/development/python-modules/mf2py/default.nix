{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  lxml,
  mock,
  poetry-core,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "mf2py";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microformats";
    repo = "mf2py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mhJ+s1rtXEJ6DqVmiyWNEK+3cdDLpR63Q4QGmD9wVio=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    beautifulsoup4
    html5lib
    requests
  ];

  nativeCheckInputs = [
    lxml
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mf2py" ];

  meta = {
    description = "Microformats2 parser written in Python";
    homepage = "https://microformats.org/wiki/mf2py";
    changelog = "https://github.com/microformats/mf2py/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
