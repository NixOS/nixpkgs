{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pypinyin";
  version = "0.47.1";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-c9pEO9k5tCFWLPismrXrrYEQYmxYKkciXFgpbrDEGzE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace \
      "--cov-report term-missing" ""
  '';

  nativeCheckInputs = [
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
