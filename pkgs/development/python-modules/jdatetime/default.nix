{
  lib,
  buildPythonPackage,
  fetchPypi,
  jalali-core,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jdatetime";
  version = "6.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-KRF4HsZBolMOnFfhBjoa2PLiDsf+7Jy86/arnbXvpHo=";
  };

  build-system = [ setuptools ];

  dependencies = [ jalali-core ];

  pythonImportsCheck = [ "jdatetime" ];

  meta = {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    changelog = "https://github.com/slashmili/python-jalali/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
})
