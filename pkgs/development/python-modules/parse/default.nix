{ lib, fetchFromGitHub
, buildPythonPackage
, setuptools
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.19.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "r1chardj0n3s";
    repo = "parse";
    rev = "refs/tags/${version}";
    hash = "sha256-f08SlkGnwhSh0ajTKFqBAGGFvLj8nWBZVb6uClbRaP4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/r1chardj0n3s/parse";
    description = "parse() is the opposite of format()";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ alunduil ];
  };
}
