{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "backports-entry-points-selectable";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "backports.entry_points_selectable";
    inherit version;
    hash = "sha256-Rwb1kXllfKfB0yWlQ+4TcPj0YzH0MrysYvqyQv3wr6U=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "backports.entry_points_selectable" ];

  pythonNamespaces = [ "backports" ];

  meta = with lib; {
    changelog = "https://github.com/jaraco/backports.entry_points_selectable/blob/v${version}/CHANGES.rst";
    description = "Compatibility shim providing selectable entry points for older implementations";
    homepage = "https://github.com/jaraco/backports.entry_points_selectable";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
