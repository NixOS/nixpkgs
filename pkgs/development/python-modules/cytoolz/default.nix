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
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p4a9nadsy1337gy2cnb5yanbn03j3zm6d9adyqad9bk3nlbpxc2";
  };

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
