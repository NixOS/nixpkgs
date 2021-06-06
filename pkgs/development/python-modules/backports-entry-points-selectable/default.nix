{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports.entry-points-selectable";
  version = "1.0.4";

  src = fetchPypi {
    inherit version;
    # pypi project name and tarball name differ
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    sha256 = "4acda84d96855beece3bf9aad9a1030aceb5f744b8ce9af7d5ee6dd672cdd3bd";
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
