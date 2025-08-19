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
  version = "1.2.11";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "pkg_about";
    inherit version;
    hash = "sha256-fm/b4Vm7YGTq+BXVltwRz42qXYULXL9KBCINB8mMuWI=";
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
