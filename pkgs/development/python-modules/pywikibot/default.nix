{
  lib,
  buildPythonPackage,
  fetchPypi,
  mwparserfromhell,
  requests,
  packaging,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pywikibot";
  version = "11.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vX9MW1miCEPkbNVUCgPZKSL120bJ1hXOAJztVqHvaDs=";
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
    mainProgram = "pwb";
    homepage = "https://www.mediawiki.org/wiki/Manual:Pywikibot";
    changelog = "https://doc.wikimedia.org/pywikibot/master/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
}
