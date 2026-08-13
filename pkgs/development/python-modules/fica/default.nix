{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # nativeBuildInputs
  pyprojectVersionPatchHook,

  # dependencies
  docutils,
  pyyaml,
  sphinx,

  # tests
  pytestCheckHook,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "fica";
  version = "0.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chrispyles";
    repo = "fica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A13xC8BGsPddsk8ZN2DeMCYc0phy/B4JD9shuoorOwg=";
  };

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = [
    # The 'fica' derivation has version '0.4.1' but .dist-info/METADATA specifies version '0.4.0'
    pyprojectVersionPatchHook
  ];

  dependencies = [
    docutils
    pyyaml
    sphinx
  ];

  pythonImportsCheck = [
    "fica"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  meta = {
    description = "Library for managing and documenting user configurations";
    homepage = "https://github.com/chrispyles/fica";
    changelog = "https://github.com/chrispyles/fica/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hhr2020 ];
  };
})
