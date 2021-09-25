{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools-scm, importlib-metadata }:

buildPythonPackage rec {
  pname = "backports-entry-points-selectable";
  version = "1.1.0";

  src = fetchPypi {
    pname = "backports.entry_points_selectable";
    inherit version;
    sha256 = "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "backports.entry_points_selectable" ];

  pythonNamespaces = [ "backports" ];

  meta = with lib; {
    description = "Compatibility shim providing selectable entry points for older implementations";
    homepage = "https://github.com/jaraco/backports.entry_points_selectable";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
