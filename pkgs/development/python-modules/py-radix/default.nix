{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-radix";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjschultz";
    repo = "py-radix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-++QuZEwOHKjOsIbwLmDy30PvyG0Xe29l45PvOF+YWYw=";
  };

  env.VERSION = finalAttrs.src.tag;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "radix" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python radix tree implementation for IPv4 and IPv6 prefix matching";
    homepage = "https://github.com/mjschultz/py-radix";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ marcel ];
  };
})
