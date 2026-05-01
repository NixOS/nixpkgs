{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mediawiki-langcodes";
  version = "0.2.21";
  pyproject = true;

  # Using fetchPypi instead of fetching from source for technical reason.
  # It required Internet and Python scripts to build the database.
  src = fetchPypi {
    pname = "mediawiki_langcodes";
    inherit (finalAttrs) version;
    hash = "sha256-WUzxMJu2PYuuxEUlLQpuVvP1F3h6+NVgH8g4ohbjenI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mediawiki_langcodes" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Convert MediaWiki language names and language codes";
    homepage = "https://github.com/xxyzz/mediawiki_langcodes";
    changelog = "https://github.com/xxyzz/mediawiki_langcodes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
  };
})
