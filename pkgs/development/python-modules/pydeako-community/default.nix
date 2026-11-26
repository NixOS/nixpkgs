{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydeako-community";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydeako-community";
    repo = "pydeako";
    tag = finalAttrs.version;
    hash = "sha256-BXB66Pt5rL0Xa9tZRsIqDTkQxmaN04iytF0jlwgzHIM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.2.1" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ zeroconf ];

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pydeako" ];

  meta = {
    description = "Discover and control Deako smart switches on the local network";
    homepage = "https://github.com/pydeako-community/pydeako";
    changelog = "https://github.com/pydeako-community/pydeako/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
