{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytz,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "l18n";
  version = "2021.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GVbokNZz0XE1zCCRMlPBVPa8HAAmbCK31QPMGlpC2Eg=";
  };

  propagatedBuildInputs = [
    pytz
    six
  ];

  # tests are not included in sdist and building from source is none trivial
  doCheck = false;

  pythonImportsCheck = [ "l18n" ];

  meta = {
    description = "Locale internationalization package";
    homepage = "https://github.com/tkhyn/l18n";
    changelog = "https://github.com/tkhyn/l18n/blob/v${finalAttrs.version}.0/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
})
