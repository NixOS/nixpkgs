{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  xeger,
}:

buildPythonPackage rec {
  pname = "raspyrfm-client";
  version = "1.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "raspyrfm-client";
    tag = version;
    hash = "sha256-+TraMrVoR8GXrjfjJnu1uyyW6KTnu8KrRqAHYU8thFw=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "raspyrfm_client" ];

  nativeCheckInputs = [
    pytestCheckHook
    xeger
  ];

  meta = {
    description = "Send rc signals with the RaspyRFM module";
    homepage = "https://github.com/markusressel/raspyrfm-client";
    changelog = "https://github.com/markusressel/raspyrfm-client/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
