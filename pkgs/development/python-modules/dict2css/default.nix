{
  buildPythonPackage,
  fetchPypi,
  whey,
  cssutils,
  lib,
}:
buildPythonPackage rec {
  pname = "dict2css";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "dict2css";
    hash = "sha256-FD5Vy3HJiojHnyxB4IpfpNh1ZZJ1dW95TjHM1pk2zog=";
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
