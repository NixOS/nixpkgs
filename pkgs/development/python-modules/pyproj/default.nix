{ lib, buildPythonPackage, fetchFromGitHub, python, pkgs, pythonOlder, isPy27, substituteAll
, aenum
, cython
, pytestCheckHook
, mock
, numpy
, shapely
}:

buildPythonPackage rec {
  pname = "pyproj";
  version = "2.6.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    rev = "v${version}rel";
    sha256 = "0fyggkbr3kp8mlq4c0r8sl5ah58bdg2mj4kzql9p3qyrkcdlgixh";
  };

  # force pyproj to use ${pkgs.proj}
  patches = [
    (substituteAll {
      src = ./001.proj.patch;
      proj = pkgs.proj;
      projdev = pkgs.proj.dev;
    })
  ];

  buildInputs = [ cython pkgs.proj ];

  propagatedBuildInputs = [
    numpy shapely
  ] ++ lib.optional (pythonOlder "3.6") aenum;

  checkInputs = [ pytestCheckHook mock ];

  # prevent importing local directory
  preCheck = "cd test";
  pytestFlagsArray = [
    "--ignore=test_doctest_wrapper.py"
    "--ignore=test_datadir.py"
  ];

  disabledTests = [
    "alternative_grid_name"
    "transform_wgs84_to_alaska"
    "transformer_group__unavailable"
    "transform_group__missing_best"
    "datum"
    "repr"
  ];

  meta = {
    description = "Python interface to PROJ.4 library";
    homepage = "https://github.com/jswhit/pyproj";
    license = with lib.licenses; [ isc ];
  };
}
