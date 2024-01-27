{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypinyin";
  version = "0.50.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    rev = "refs/tags/v${version}";
    hash = "sha256-9RnuC9AvTlUtZqep6kn5y1xQcq/dzA9jTZXAsMpKZWc=";
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
    changelog = "https://github.com/mozillazg/python-pinyin/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
