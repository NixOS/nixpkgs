{
  buildPythonPackage,
  copier,
  corallium,
  fetchFromGitHub,
  lib,
  uv-build,
}:
buildPythonPackage rec {
  pname = "copier-template-tester";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "copier-template-tester";
    tag = version;
    hash = "sha256-eWTrrvZGucHYJVZfhCZSJJQGSqhXLSf8Rp4ZPsGxsIw=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    copier
    corallium
  ];

  meta = {
    description = "CLI and pre-commit tool for testing copier";
    homepage = "https://copier-template-tester.kyleking.me";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
