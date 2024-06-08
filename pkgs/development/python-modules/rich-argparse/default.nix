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
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hamdanal";
    repo = "rich-argparse";
    rev = "refs/tags/v${version}";
    hash = "sha256-NcsEGImUAqwZI6Ga3UIqnoELvz6WRKyVqGkR4jPIKPI=";
  };

  build-system = [ hatchling ];

  dependencies = [ rich ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_argparse" ];

  meta = with lib; {
    description = "Format argparse help output using rich";
    homepage = "https://github.com/hamdanal/rich-argparse";
    changelog = "https://github.com/hamdanal/rich-argparse/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}
