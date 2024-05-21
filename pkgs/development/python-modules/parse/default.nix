{ lib, fetchFromGitHub
, buildPythonPackage
, setuptools
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "parse";
  version = "1.20.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "r1chardj0n3s";
    repo = "parse";
    rev = "refs/tags/${version}";
    hash = "sha256-FAAs39peR+Ibv0RKLrcnY2w0Z2EjVYyZ8U4HcbjTiew=";
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
