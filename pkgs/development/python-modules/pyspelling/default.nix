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
  version = "2.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rNZxM8G3zs1BDj1EieYfLksfC2rPGubEjCQPuyFynDc=";
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
    description = "Spell checker";
    homepage = "https://pypi.org/project/pyspelling";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
