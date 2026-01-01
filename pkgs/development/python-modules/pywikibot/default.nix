{
  lib,
  buildPythonPackage,
  fetchPypi,
  mwparserfromhell,
  requests,
  packaging,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pywikibot";
<<<<<<< HEAD
  version = "10.7.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/hHfZRLoEgaPKZLus9x/d5O62GnwU/1A7PAsebGj634=";
  };

  build-system = [ setuptools ];

  dependencies = [
=======
  version = "10.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-waO9rPadF5N65s0mOrIhr/OJW9Ax5f9uRUoUyRMWDIw=";
  };

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
