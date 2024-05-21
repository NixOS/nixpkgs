{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
  version = "0.8.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyspellchecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-8IwTMj/RqMc9UqhzyvmrirPGuMEwj3iMr+FmF+8312U=";
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
