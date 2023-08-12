{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaconv";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ikegami-yukino";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9ruhOLaYNESeKOwJs3IN6ct66fSq7My9DOyA7/cH3d0=";
  };

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jaconv"
  ];

  meta = with lib; {
    description = "Python Japanese character interconverter for Hiragana, Katakana, Hankaku and Zenkaku";
    homepage = "https://github.com/ikegami-yukino/jaconv";
    changelog = "https://github.com/ikegami-yukino/jaconv/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
