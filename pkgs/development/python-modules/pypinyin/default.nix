{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pypinyin";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    rev = "v${version}";
    sha256 = "1s01dd5n6cgjg24dmji0abxkyvr1yi18lx4rpm9z54v0q3wkccg9";
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
    maintainers = with maintainers; [ hexa mic92 ];
  };
}
