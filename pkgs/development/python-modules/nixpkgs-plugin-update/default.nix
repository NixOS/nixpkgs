{
  lib,
  buildPythonPackage,
  uv-build,
  gitpython,
  ruff,
  mypy,
}:

buildPythonPackage {
  pname = "nixpkgs-plugin-update";
  version = "0.1.0";
  format = "pyproject";

  src = ./nixpkgs-plugin-update;

  build-system = [ uv-build ];

  dependencies = [
    gitpython
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
    maintainers = [
      lib.maintainers.teto
      lib.maintainers.perchun
      lib.maintainers.khaneliman
    ];
  };
}
