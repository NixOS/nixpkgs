{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  jinja2,
  markupsafe,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jinjax";
  version = "0.48";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpsca";
    repo = "jinjax";
    tag = version;
    hash = "sha256-NPq9LLfAGWcT7yejrMUh9x/Ho84sTGz3Www6dyTchoU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    jinja2
    markupsafe
  ];

  pythonImportsCheck = [ "jinjax" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Server-Side Components with Jinja";
    homepage = "https://github.com/jpsca/jinjax";
    changelog = "https://github.com/jpsca/jinjax/releases/tag/${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
