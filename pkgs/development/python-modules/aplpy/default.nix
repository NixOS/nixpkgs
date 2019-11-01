{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-helpers
, matplotlib
, reproject
, pyavm
, pyregion
, pillow
, scikitimage
, shapely
, pytest
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.0.3";

  src = fetchPypi {
    pname = "APLpy";
    inherit version;
    sha256 = "239f3d83635ca4251536aeb577df7c60df77fc4d658097b92094719739aec3f3";
  };

  propagatedBuildInputs = [
    numpy
    astropy
    matplotlib
    reproject
    pyavm
    pyregion
    pillow
    scikitimage
    shapely
  ];

  nativeBuildInputs = [ astropy-helpers ];

  checkInputs = [ pytest pytest-astropy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  # Tests must be run in the build directory
  checkPhase = ''
    cd build/lib
    pytest
  '';

  meta = with lib; {
    description = "The Astronomical Plotting Library in Python";
    homepage = http://aplpy.github.io;
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
