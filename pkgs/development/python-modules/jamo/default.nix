{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jamo";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JDongian";
    repo = "python-jamo";
    tag = "v${version}";
    hash = "sha256-QHI3Rqf1aQOsW49A/qnIwRnPuerbtyerf+eWIiEvyho=";
  };

  pythonImportsCheck = [ "jamo" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/JDongian/python-jamo/releases/tag/v${version}";
    description = "Hangul syllable decomposition and synthesis using jamo";
    homepage = "https://github.com/JDongian/python-jamo";
    license = licenses.asl20;
    teams = [ teams.tts ];
  };
}
