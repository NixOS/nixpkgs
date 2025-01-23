{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  importlib-resources,
  setuptools,
  packaging,
  tomli,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkg-about";
  version = "1.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pkg_about";
    inherit version;
    extension = "zip";
    hash = "sha256-GVV3l0rU8gkxedOiMVVAt0bEqCtyO+1LSHxIKjBlbPk=";
  };

  # tox is listed in build requirements but not actually used to build
  # keeping it as a requirement breaks the build unnecessarily
  postPatch = ''
    sed -i "/requires/s/, 'tox>=[^']*'//" pyproject.toml
  '';

  nativeBuildInputs = [
    packaging
    setuptools
  ];

  propagatedBuildInputs = [
    importlib-metadata
    importlib-resources
    packaging
    setuptools
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkg_about" ];

  meta = with lib; {
    description = "Python metadata sharing at runtime";
    homepage = "https://github.com/karpierz/pkg_about/";
    changelog = "https://github.com/karpierz/pkg_about/blob/${version}/CHANGES.rst";
    license = licenses.zlib;
    maintainers = teams.ororatech.members;
  };
}
