{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools-scm, importlib-metadata }:

buildPythonPackage rec {
  pname = "backports-entry-points-selectable";
  version = "1.1.1";

  src = fetchPypi {
    pname = "backports.entry_points_selectable";
    inherit version;
    sha256 = "914b21a479fde881635f7af5adc7f6e38d6b274be32269070c53b698c60d5386";
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
