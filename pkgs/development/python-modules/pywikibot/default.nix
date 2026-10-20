{
  lib,
  buildPythonPackage,
  fetchPypi,
  mwparserfromhell,
  requests,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywikibot";
  version = "11.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+Rkw0Vke/qR19I8pTzKH2C9+5iQLPTikDl0xtSy4zME=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mwparserfromhell
    requests
    packaging
  ];

  # Tests attempt to install a tool using pip, which fails due to the sandbox
  doCheck = false;

  pythonImportsCheck = [ "pywikibot" ];

  meta = {
    description = "Python MediaWiki bot framework";
    homepage = "https://www.mediawiki.org/wiki/Manual:Pywikibot";
    changelog = "https://doc.wikimedia.org/pywikibot/master/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
    mainProgram = "pwb";
  };
})
