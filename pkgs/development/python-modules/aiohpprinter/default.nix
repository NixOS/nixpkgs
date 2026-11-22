{
  lib,
  aiohttp,
  anyio,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohpprinter";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiohpprinter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A1bO9XlZ853QEOX9xP16CE/QYeb7kj+gtkPxm20psaM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.2.1" "setuptools"
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    defusedxml
  ];

  nativeCheckInputs = [
    anyio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohpprinter" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library to get information from HP printers";
    homepage = "https://github.com/chemelli74/aiohpprinter";
    changelog = "https://github.com/chemelli74/aiohpprinter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
