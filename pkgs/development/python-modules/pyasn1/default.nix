{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyasn1";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyasn1";
    repo = "pyasn1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZtsHANVUGk+LF17dEjePDm8ofX61P4f2/BTHqlscNd0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyasn1" ];

  meta = {
    description = "Generic ASN.1 library for Python";
    homepage = "https://pyasn1.readthedocs.io";
    changelog = "https://github.com/pyasn1/pyasn1/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
