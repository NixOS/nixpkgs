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
  version = "1.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-B5u+iJuqHtv4BlGhdWqYxBfS89/S01OXmLyDOQraHfo=";
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
