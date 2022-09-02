{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pypinyin";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DsSrWbnBFEGQTXP1+C8j5RqSplDitsFl+13YwwE+3pE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace \
      "--cov-report term-missing" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests"
  ];

  meta = with lib; {
    description = "Chinese Characters to Pinyin - 汉字转拼音";
    homepage = "https://github.com/mozillazg/python-pinyin";
    changelog = "https://github.com/mozillazg/python-pinyin/blob/master/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
