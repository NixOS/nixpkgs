{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  numpy,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "fastnumbers";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SethMMorton";
    repo = "fastnumbers";
    tag = version;
    hash = "sha256-7UjUkZPGsrtdQhgisI5IA37WvgGGiEXsey9NhATy064=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ typing-extensions ];

  # Tests fail due to numeric precision differences on ARM
  # See https://github.com/SethMMorton/fastnumbers/issues/28
  doCheck = !stdenv.hostPlatform.isAarch;

  nativeCheckInputs = [
    hypothesis
    numpy
    pytestCheckHook
  ];

  pytestFlags = [ "--hypothesis-profile=standard" ];

  pythonImportsCheck = [ "fastnumbers" ];

  meta = {
    description = "Python module for number conversion";
    homepage = "https://github.com/SethMMorton/fastnumbers";
    changelog = "https://github.com/SethMMorton/fastnumbers/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
