{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pypinyin";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    rev = "v${version}";
    sha256 = "sha256-LYiiZvpM/V3QRyTUXGWGnSnR0AnqWfTW0xJB4Vnw7lI=";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace \
      "--cov-report term-missing" ""
  '';

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests" ];

  meta = with lib; {
    description = "Chinese Characters to Pinyin - 汉字转拼音";
    homepage = "https://github.com/mozillazg/python-pinyin";
    changelog =
      "https://github.com/mozillazg/python-pinyin/blob/master/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
