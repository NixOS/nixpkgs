{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hikvision";
  version = "2.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fbradyirl";
    repo = "hikvision";
    tag = "v${version}";
    hash = "sha256-tiJUqr5WtRvnKll1OymJ9Uva1tUT5so4Zzc4SHLcH9A=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hikvision.api" ];

  meta = with lib; {
    description = "Python module for interacting with Hikvision IP Cameras";
    homepage = "https://github.com/fbradyirl/hikvision";
    changelog = "https://github.com/fbradyirl/hikvision/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
