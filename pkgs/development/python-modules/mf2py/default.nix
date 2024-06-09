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
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "mf2py";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microformats";
    repo = "mf2py";
    rev = "refs/tags/v${version}";
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

  meta = with lib; {
    description = "Microformats2 parser written in Python";
    homepage = "https://microformats.org/wiki/mf2py";
    changelog = "https://github.com/microformats/mf2py/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
