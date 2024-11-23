{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,

  asn1crypto,
  click,
  apksigcopier,
  cryptography,
  pyasn1,
  pyasn1-modules,
  simplejson,
}:

buildPythonPackage rec {
  pname = "apksigtool";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "apksigtool";
    rev = "refs/tags/v${version}";
    hash = "sha256-22dQLH9iMy+UqC90fGZ0STpU55+922SzQTR+dztl6R8=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    asn1crypto
    apksigcopier
    click
    cryptography
    pyasn1
    pyasn1-modules
    simplejson
  ];

  pythonImportsCheck = [ "apksigtool" ];

  meta = {
    description = "Parse android APK Signing Blocks and verify APK signatures";
    homepage = "https://github.com/obfusk/apksigtool/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
