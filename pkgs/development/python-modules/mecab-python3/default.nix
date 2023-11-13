{ lib
, buildPythonPackage
, fetchPypi
, mecab
, swig
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mecab-python3";
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2ZM79P2UQmD1i0Ifhjm7wRIEE9Hz/N6MVQlyIdwT1R0=";
  };

  nativeBuildInputs = [
    mecab # for mecab-config
    swig
    setuptools-scm
  ];

  buildInputs = [
    mecab
  ];

  doCheck = false;

  pythonImportsCheck = [
    "MeCab"
  ];

  meta = with lib; {
    description = "A python wrapper for mecab: Morphological Analysis engine";
    homepage =  "https://github.com/SamuraiT/mecab-python3";
    changelog = "https://github.com/SamuraiT/mecab-python3/releases/tag/v${version}";
    license = with licenses; [ gpl2 lgpl21 bsd3 ]; # any of the three
    maintainers = with maintainers; [ ixxie ];
  };
}
