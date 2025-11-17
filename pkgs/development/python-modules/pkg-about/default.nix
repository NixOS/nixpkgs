{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  importlib-resources,
  setuptools,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkg-about";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "pkg_about";
    inherit version;
    hash = "sha256-hgQOmp+R4ZWbq8hKRUQQzMO4hl/pHAGiJK9c4lxEkaI=";
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
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkg_about" ];

  meta = with lib; {
    description = "Python metadata sharing at runtime";
    homepage = "https://github.com/karpierz/pkg_about/";
    changelog = "https://github.com/karpierz/pkg_about/blob/${version}/CHANGES.rst";
    license = licenses.zlib;
    teams = [ teams.ororatech ];
  };
}
