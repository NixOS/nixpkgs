{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, nose
, toolz
, python
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.9.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ebb55855a8bb7800afa58e52408763935527e0305f35600c71b43c86013dec2";
  };

  # Extension types
  disabled = isPyPy;

  checkInputs = [ nose ];
  propagatedBuildInputs = [ toolz ];

  # File as accidentally included in release
  # See https://github.com/pytoolz/cytoolz/issues/116#issuecomment-355770073
  postPatch = ''
    rm cytoolz/tests/test_curried_doctests.py
  '';

  # Disable failing test https://github.com/pytoolz/cytoolz/issues/97
  checkPhase = ''
    NOSE_EXCLUDE=test_curried_exceptions nosetests -v $out/${python.sitePackages}
  '';

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}