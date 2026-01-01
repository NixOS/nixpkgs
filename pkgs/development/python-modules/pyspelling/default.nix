{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  beautifulsoup4,
  html5lib,
  lxml,
  markdown,
  pyyaml,
  soupsieve,
  wcmatch,
}:

buildPythonPackage rec {
  pname = "pyspelling";
<<<<<<< HEAD
  version = "2.12.1";
=======
  version = "2.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-kQiYHcF01kAKftSRfPSvkdrz64NXjUVwwHJrksKjLno=";
=======
    hash = "sha256-ezl5EeRrf6fBBWsoZ8AugVR/yNALvNhEZWVd8j5J26o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    html5lib
    lxml
    markdown
    pyyaml
    soupsieve
    wcmatch
  ];

  pythonImportsCheck = [
    "pyspelling"
  ];

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/facelessuser/pyspelling/blob/${version}/docs/src/markdown/about/changelog.md";
    description = "Spell checker";
    homepage = "https://pypi.org/project/pyspelling";
    license = lib.licenses.mit;
    mainProgram = "pyspelling";
=======
    description = "Spell checker";
    homepage = "https://pypi.org/project/pyspelling";
    license = lib.licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
