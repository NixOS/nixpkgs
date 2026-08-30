{
  buildPythonPackage,
  fetchPypi,
  whey,
  cssutils,
  lib,
}:
buildPythonPackage rec {
  pname = "dict2css";
  version = "0.3.0.post1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "dict2css";
    hash = "sha256-icVEwhxMp0csP/+50309km9gYymv23Udwd5npBG3Bxk=";
  };

  build-system = [ whey ];

  dependencies = [ cssutils ];

  pythonImportsCheck = [ "dict2css" ];

  meta = {
    description = "μ-library for constructing cascading style sheets from Python dictionaries";
    homepage = "https://github.com/sphinx-toolbox/dict2css";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
