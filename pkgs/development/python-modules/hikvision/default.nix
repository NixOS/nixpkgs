{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hikvision";
  version = "2.0.4";
  pyproject = true;

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

  meta = {
    description = "Python module for interacting with Hikvision IP Cameras";
    homepage = "https://github.com/fbradyirl/hikvision";
    changelog = "https://github.com/fbradyirl/hikvision/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
