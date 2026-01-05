{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  jaraco-classes,
  jaraco-text,
}:

buildPythonPackage rec {
  pname = "jaraco-collections";
  version = "5.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jaraco_collections";
    inherit version;
    hash = "sha256-2rgZcLrW8KtTsgdF8bAdo3km5MD81CUEaqReDY76GO0=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jaraco-classes
    jaraco-text
  ];

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;

  pythonImportsCheck = [ "jaraco.collections" ];

  meta = with lib; {
    description = "Models and classes to supplement the stdlib 'collections' module";
    homepage = "https://github.com/jaraco/jaraco.collections";
    changelog = "https://github.com/jaraco/jaraco.collections/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
