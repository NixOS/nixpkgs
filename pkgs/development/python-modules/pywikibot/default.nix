{
  lib,
  buildPythonPackage,
  fetchPypi,
  mwparserfromhell,
  requests,
  packaging,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pywikibot";
  version = "10.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QXgv++Vr2HYzoAAwk2eVg/EnKqX9EFUJo6OBHvlYbjQ=";
  };

  propagatedBuildInputs = [
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
