{ lib, fetchFromGitHub
, buildPythonPackage
, setuptools
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.20.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "r1chardj0n3s";
    repo = "parse";
    rev = "refs/tags/${version}";
    hash = "sha256-InYOgqTvMvQ/HWIa0WrJ4M2LL4LL87KwBst8yYnt3dk=";
  };

  postPatch = ''
    rm .pytest.ini
  '';

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
