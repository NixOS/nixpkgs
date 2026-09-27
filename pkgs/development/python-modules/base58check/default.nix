{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "base58check";
  version = "1.0.2";
  pyproject = true;

  __structuredAttrs = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "joeblackwaslike";
    repo = "base58check";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tig6beLRDsXC//x4+t/z2BGaJQWzcP0J+QEKx3D0rhs=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "base58check" ];

  meta = {
    description = "Implementation of the Base58Check encoding scheme";
    homepage = "https://github.com/joeblackwaslike/base58check";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
