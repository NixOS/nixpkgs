{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "grimp";
  version = "3.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GnM7HXGcQr0vraWCQJdfp9CZNrVxIMNLZM+zHkJwEBA=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "grimp-${version}/${cargoRoot}";
    hash = "sha256-85MKqQ77mjUdjDZP6pvAN7HQvzaEIukDl7Pl+YS1HSM=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  meta = {
    description = "Builds a queryable graph of the imports within one or more Python packages";
    homepage = "https://github.com/python-grimp/grimp";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sloschert ];
  };
}
