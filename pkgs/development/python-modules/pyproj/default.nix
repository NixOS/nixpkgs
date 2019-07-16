{ lib, buildPythonPackage, fetchPypi, python, pkgs, pythonOlder, substituteAll
, aenum
, cython
, pytest
, mock
, numpy
}:

buildPythonPackage rec {
  pname = "pyproj";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yigcxwmx5cczipf2mpmy2gq1dnl0635yjvjq86ay47j1j5fd2gc";
  };

  # force pyproj to use ${pkgs.proj}
  patches = [
    (substituteAll {
      src = ./001.proj.patch;
      proj = pkgs.proj;
    })
  ];

  buildInputs = [ cython pkgs.proj ];

  propagatedBuildInputs = [
    numpy
  ] ++ lib.optional (pythonOlder "3.6") aenum;

  checkInputs = [ pytest mock ];

  # ignore rounding errors, and impure docgen
  # datadir is ignored because it does the proj look up logic, which isn't relevant
  checkPhase = ''
    pytest . -k 'not alternative_grid_name \
                 and not transform_wgs84_to_alaska \
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
