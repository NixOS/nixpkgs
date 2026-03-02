{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  importlib-metadata,
  importlib-resources,
  setuptools,
  packaging,
  typing-extensions,
  appdirs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkg-about";
  version = "2.0.12";
  pyproject = true;

  src = fetchPypi {
    pname = "pkg_about";
    inherit version;
    hash = "sha256-WFhOMeBvAPaU/AIGoGlSziJ633TrGBgOcbfBxAm3H8E=";
  };

  # tox is listed in build requirements but not actually used to build
  # keeping it as a requirement breaks the build unnecessarily
  postPatch = ''
    sed -i "/requires/s/, 'tox>=[^']*'//" pyproject.toml
  '';

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    docutils
    importlib-metadata
    importlib-resources
    packaging
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [
    appdirs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pkg_about" ];

  meta = {
    description = "Python metadata sharing at runtime";
    homepage = "https://github.com/karpierz/pkg_about/";
    changelog = "https://github.com/karpierz/pkg_about/blob/${version}/CHANGES.rst";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ kip93 ];
  };
}
