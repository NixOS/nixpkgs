{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jamo";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JDongian";
    repo = "python-jamo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QHI3Rqf1aQOsW49A/qnIwRnPuerbtyerf+eWIiEvyho=";
  };

  pythonImportsCheck = [ "jamo" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/JDongian/python-jamo/releases/tag/v${finalAttrs.version}";
    description = "Hangul syllable decomposition and synthesis using jamo";
    homepage = "https://github.com/JDongian/python-jamo";
    license = lib.licenses.asl20;
    teams = [ lib.teams.tts ];
  };
})
