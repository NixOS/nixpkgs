{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports.entry-points-selectable";
  version = "1.1.0";

  src = fetchPypi {
    inherit version;
    # pypi project name and tarball name differ
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    sha256 = "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a";
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
