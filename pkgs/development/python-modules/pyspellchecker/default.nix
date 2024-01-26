{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
  version = "0.7.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyspellchecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-DUFJGO0Ncobr36k0hQRgeHf77Mds53JJHOMlf4/zfAI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pure python spell checking";
    homepage = "https://github.com/barrust/pyspellchecker";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
