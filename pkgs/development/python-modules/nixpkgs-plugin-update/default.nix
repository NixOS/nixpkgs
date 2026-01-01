{
  lib,
  buildPythonPackage,
  uv-build,
  gitpython,
<<<<<<< HEAD
  packaging,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    packaging
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      teto
      PerchunPak
      khaneliman
=======
    maintainers = [
      lib.maintainers.teto
      lib.maintainers.perchun
      lib.maintainers.khaneliman
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
