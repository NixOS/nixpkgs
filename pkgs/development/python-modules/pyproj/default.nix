{ lib, buildPythonPackage, fetchFromGitHub, python, pkgs, pythonOlder, isPy27, substituteAll
, aenum
, cython
, pytest
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

  checkInputs = [ pytest mock ];

  # ignore rounding errors, and impure docgen
  # datadir is ignored because it does the proj look up logic, which isn't relevant
  checkPhase = ''
    pytest . -k 'not alternative_grid_name \
                 and not transform_wgs84_to_alaska \
                 and not transformer_group__unavailable \
                 and not transform_group__missing_best \
                 and not datum \
                 and not repr' \
            --ignore=test/test_doctest_wrapper.py \
            --ignore=test/test_datadir.py
  '';

  meta = {
    description = "Python interface to PROJ.4 library";
    homepage = "https://github.com/jswhit/pyproj";
    license = with lib.licenses; [ isc ];
  };
}
