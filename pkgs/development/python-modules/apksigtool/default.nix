{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  apksigcopier,
  asn1crypto,
  click,
  cryptography,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "apksigtool";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "apksigtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22dQLH9iMy+UqC90fGZ0STpU55+922SzQTR+dztl6R8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apksigcopier
    asn1crypto
    click
    cryptography
    simplejson
  ];

  # TODO has shell tests, no idea how to invoke them

  pythonImportsCheck = [ "apksigtool" ];

  meta = {
    description = "Tool to parse/verify/clean/sign android apk";
    homepage = "https://github.com/obfusk/apksigtool";
    changelog = "https://github.com/obfusk/apksigtool/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
