{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  rich,
}:

buildPythonPackage rec {
  pname = "rich-argparse";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hamdanal";
    repo = "rich-argparse";
    tag = "v${version}";
    hash = "sha256-XuRQeE9JrF4ym2H1ky1yH0fENnsWbL90vboQzTo23w0=";
  };

  build-system = [ hatchling ];

  dependencies = [ rich ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_argparse" ];

  meta = with lib; {
    description = "Format argparse help output using rich";
    homepage = "https://github.com/hamdanal/rich-argparse";
    changelog = "https://github.com/hamdanal/rich-argparse/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}
