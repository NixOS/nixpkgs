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
  version = "0.8.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "476a2ad176de5eaef80499b7b43d4f72ba6d23df33d349088dae315e9b31c552";
  };

  # Extension types
  disabled = isPyPy;

  checkInputs = [ nose ];
  propagatedBuildInputs = [ toolz ];

  # Disable failing test https://github.com/pytoolz/cytoolz/issues/97
  checkPhase = ''
    NOSE_EXCLUDE=test_curried_exceptions nosetests -v $out/${python.sitePackages}
  '';

  meta = {
    homepage = "http://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}