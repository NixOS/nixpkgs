{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, nose
, toolz
, python
, fetchpatch
, isPy27
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.11.0";
  disabled = isPy27 || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c64f3590c3eb40e1548f0d3c6b2ccde70493d0b8dc6cc7f9f3fec0bb3dcd4222";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ toolz ];

  checkPhase = ''
    nosetests -v $out/${python.sitePackages}
  '';

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
