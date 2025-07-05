{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pypinyin";
  version = "0.54.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    tag = "v${version}";
    hash = "sha256-kA6h2CPGhoZt8h3KEttegHhmMqVc72IkrkA3PonY3sY=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pytestFlagsArray = [ "tests" ];

  meta = with lib; {
    description = "Chinese Characters to Pinyin - 汉字转拼音";
    mainProgram = "pypinyin";
    homepage = "https://github.com/mozillazg/python-pinyin";
    changelog = "https://github.com/mozillazg/python-pinyin/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
