{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-healpix
, astropy-helpers
, scipy
, pytest
, pytest-astropy
, cython
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "484fde86d70d972d703038f138d7c2966ddf51171a6e79bd84e82ea270e27af3";
  };

  propagatedBuildInputs = [ numpy astropy astropy-healpix astropy-helpers scipy ];

  nativeBuildInputs = [ astropy-helpers cython ];

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
    homepage = https://reproject.readthedocs.io;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
