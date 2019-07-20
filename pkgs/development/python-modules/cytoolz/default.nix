{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, nose
, toolz
, python
, fetchpatch
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.9.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84cc06fa40aa310f2df79dd440fc5f84c3e20f01f9f7783fc9c38d0a11ba00e5";
  };

  patches = [
    # temporal fix for a test failure: https://github.com/pytoolz/cytoolz/issues/122
    (fetchpatch {
      name = "py37.patch";
      url = https://salsa.debian.org/python-team/modules/python-cytoolz/raw/5ce4158deefc47475d1e76813f900e6c72ddcc6e/debian/patches/py37.patch;
      sha256 = "1z29y7s5n751q3f74r3bz0f48yg6izvi68hc4pkwcalxmkq5r1n9";
    })
  ];

  # Extension types
  disabled = isPyPy;

  checkInputs = [ nose ];
  propagatedBuildInputs = [ toolz ];

  # Failing test https://github.com/pytoolz/cytoolz/issues/122
  checkPhase = ''
    NOSE_EXCLUDE=test_introspect_builtin_modules nosetests -v $out/${python.sitePackages}
  '';

  meta = {
    homepage = https://github.com/pytoolz/cytoolz/;
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
