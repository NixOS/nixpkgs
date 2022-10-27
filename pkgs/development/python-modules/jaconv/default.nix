{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaconv";
  version = "0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ikegami-yukino";
    repo = pname;
    rev = "v${version}";
    sha256 = "rityHi1JWWlV7+sAxNrlbcmfHmORZWrMZqXTRlsclhQ=";
  };

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jaconv"
  ];

  meta = with lib; {
    description = "Python Japanese character interconverter for Hiragana, Katakana, Hankaku and Zenkaku";
    homepage = "https://github.com/ikegami-yukino/jaconv";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
