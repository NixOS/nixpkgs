{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysnmp-pyasn1";
  version = "2.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pyasn1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kgnIuPX1eA1oK61oKIPAdix7qrKWYQ9dtgGnTXqVsnE=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [ "pyasn1" ];

  meta = {
    description = "Python ASN.1 encoder and decoder";
    homepage = "https://github.com/pysnmp/pyasn1";
    changelog = "https://github.com/pysnmp/pyasn1/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
