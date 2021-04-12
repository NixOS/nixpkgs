{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports.entry-points-selectable";
  version = "1.0.3";

  src = fetchPypi {
    inherit version;
    # pypi project name and tarball name differ
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    sha256 = "f30bcd19c5e2728ac93821d2b6ae0a325597e0ca12324fd91a39fa80e1cd0dd8";
  };

  format = "pyproject";

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Compatibility shim providing selectable entry points for older implementations";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/jaraco/backports.entry_points_selectable";
  };
}
