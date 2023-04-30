{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
  version = "0.7.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyspellchecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-DV2JxUKTCVJRRLmi+d5dMloCgpYwC5uyI1o34L26TxA=";
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
