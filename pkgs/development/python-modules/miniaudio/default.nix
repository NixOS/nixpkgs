{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.70";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    tag = "v${version}";
    hash = "sha256-7i1ORJJwdd/an5IsW/xO1puI/LJJ5WDEdaE8DU4/laQ=";
  };

  # TODO: Properly unvendor miniaudio c library

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [ cffi ];
  dependencies = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "miniaudio" ];

  meta = {
    changelog = "https://github.com/irmen/pyminiaudio/releases/tag/v${version}";
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
