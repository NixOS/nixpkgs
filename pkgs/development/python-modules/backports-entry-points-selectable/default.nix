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
    sha256 = "0shz6rkpidyw3bayad03274p4m1g1qk4j4dfnvd9dhf11qk6i14q";
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
