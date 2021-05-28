{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, numpy
, astropy
, astropy-healpix
, astropy-helpers
, extension-helpers
, scipy
, pytest
, pytest-astropy
, setuptools_scm
, cython
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jsc3ad518vyys5987fr1achq8qvnz8rm80zp5an9qxlwr4zmh4m";
  };

  propagatedBuildInputs = [ numpy astropy astropy-healpix astropy-helpers scipy ];

  nativeBuildInputs = [ astropy-helpers cython extension-helpers setuptools_scm ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  checkInputs = [ pytest pytest-astropy ];

  # Tests must be run in the build directory
  checkPhase = ''
    cd build/lib*
    pytest
  '';

  meta = with lib; {
    description = "Reproject astronomical images";
    homepage = "https://reproject.readthedocs.io";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
