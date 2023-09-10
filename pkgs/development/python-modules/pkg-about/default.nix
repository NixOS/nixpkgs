{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, importlib-resources
, setuptools
, packaging
, tomli
, tox
}:

buildPythonPackage rec {
  pname = "pkg-about";
  version = "1.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pkg_about";
    inherit version;
    extension = "zip";
    hash = "sha256-mb43XbKypgilagXLW33kP8wXxioNsfLtl6AEnOI1WlA=";
  };

  nativeBuildInputs = [
    packaging
    setuptools
    tox
  ];

  propagatedBuildInputs = [
    importlib-metadata
    importlib-resources
    packaging
    setuptools
    tomli
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pkg_about"
  ];

  meta = with lib; {
    description = "Python metadata sharing at runtime";
    homepage = "https://github.com/karpierz/pkg_about/";
    changelog = "https://github.com/karpierz/pkg_about/blob/${version}/CHANGES.rst";
    license = licenses.zlib;
    maintainers = [ teams.ororatech ];
  };
}
