{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  docutils,
  pyyaml,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "fica";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrispyles";
    repo = "fica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A13xC8BGsPddsk8ZN2DeMCYc0phy/B4JD9shuoorOwg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    docutils
    pyyaml
    sphinx
  ];

  pythonImportsCheck = [
    "fica"
  ];

  meta = {
    description = "Library for managing and documenting user configurations";
    homepage = "https://github.com/chrispyles/fica";
    changelog = "https://github.com/chrispyles/fica/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hhr2020 ];
  };
})
