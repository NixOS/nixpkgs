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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed9f6a07c2bac70d6c597df360d0666d11d2adc90141d54c5c2db08b380a4fac";
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
