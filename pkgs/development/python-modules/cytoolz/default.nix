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
  version = "0.9.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84cc06fa40aa310f2df79dd440fc5f84c3e20f01f9f7783fc9c38d0a11ba00e5";
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
    homepage = https://github.com/pytoolz/cytoolz/;
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}