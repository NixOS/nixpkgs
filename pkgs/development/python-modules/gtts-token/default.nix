{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gtts-token";
  version = "1.1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "boudewijn26";
    repo = "gTTS-token";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FyI7m3ppqyn6pcIHHUVvbOga1QryGMqY3s5jCdgXJW8=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires internet access
  disabledTests = [ "test_real" ];

  pythonImportsCheck = [ "gtts_token" ];

  meta = {
    description = "Calculates a token to run the Google Translate text to speech";
    homepage = "https://github.com/boudewijn26/gTTS-token";
    changelog = "https://github.com/Boudewijn26/gTTS-token/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
