{
  lib,
  buildPythonPackage,
  fetchPypi,
  build,
  importlib-metadata,
  setuptools,
  packaging,
  typing-extensions,
  appdirs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkg-about";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pkg_about";
    inherit version;
    hash = "sha256-g+RduU/aLD+UwZVexONXa8+rQznVmybC5G4ZnIugPqI=";
  };

  # Unnecessarily requires the newest versions available for these
  postPatch = ''
    sed -i 's/"setuptools>=[^"]*"/"setuptools>=${setuptools.version}"/' pyproject.toml
    sed -i 's/"packaging>=[^"]*"/"packaging>=${packaging.version}"/' pyproject.toml
  '';

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    build
    importlib-metadata
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [
    appdirs
    pytestCheckHook
  ];

  # Tries and fails to install itself via pip
  disabledTests = [ "test_about_from_setup" ];

  pythonImportsCheck = [ "pkg_about" ];

  meta = {
    description = "Python metadata sharing at runtime";
    homepage = "https://github.com/karpierz/pkg_about/";
    changelog = "https://github.com/karpierz/pkg_about/blob/${version}/CHANGES.rst";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ kip93 ];
  };
}
