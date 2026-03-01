{
  lib,
  buildPythonPackage,
  uv-build,
  gitpython,
  packaging,
  ruff,
  mypy,
}:

buildPythonPackage {
  pname = "nixpkgs-plugin-update";
  version = "0.1.0";
  pyproject = true;

  src = ./nixpkgs-plugin-update;

  build-system = [ uv-build ];

  dependencies = [
    gitpython
    packaging
  ];

  nativeCheckInputs = [
    ruff
    mypy
  ];

  postInstallCheck = ''
    ruff check
    mypy
  '';

  meta = {
    description = "Library for updating plugin collections in Nixpkgs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teto
      PerchunPak
      khaneliman
    ];
  };
}
