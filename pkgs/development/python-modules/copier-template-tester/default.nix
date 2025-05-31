{
  buildPythonPackage,
  copier,
  corallium,
  fetchFromGitHub,
  lib,
  poetry-core,
  poetry-dynamic-versioning,
}:
buildPythonPackage rec {
  pname = "copier-template-tester";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = version;
    hash = "sha256-q1SNsy5CbBmGTGVejSN8P8BkdiasZjnW8BWMXOfSD1s=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    copier
    corallium
  ];

  meta = with lib; {
    description = "ctt: CLI and pre-commit tool for testing copier";
    homepage = "https://copier-template-tester.kyleking.me";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
