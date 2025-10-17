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

buildPythonPackage rec {
  pname = "apksigtool";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "apksigtool";
    tag = "v${version}";
    hash = "sha256-22dQLH9iMy+UqC90fGZ0STpU55+922SzQTR+dztl6R8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  buildInputs = [
    apksigcopier
    asn1crypto
    click
    cryptography
    simplejson
  ];

  # TODO fails somehow
  doCheck = false;
  #pythonImportsCheck = [ "apksigtool" ];

  meta = {
    description = "apksigtool - parse/verify/clean/sign android apk";
    homepage = "https://github.com/obfusk/apksigtool";
    changelog = "https://github.com/obfusk/apksigtool/releases/tag/${src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
