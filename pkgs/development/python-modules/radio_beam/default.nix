{ lib
, fetchPypi
, buildPythonPackage
, astropy
, pytest
, pytest-astropy
, astropy-helpers
, scipy
}:

buildPythonPackage rec {
  pname = "radio_beam";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g1nqiikv023ab60gfqrvc13kfjv8m70bpfk264vlliaq6mvxdf2";
  };

  propagatedBuildInputs = [ astropy ];

  nativeBuildInputs = [ astropy-helpers ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  checkInputs = [ pytest pytest-astropy scipy ];

  # Tests must be run in the build directory
  checkPhase = ''
    cd build/lib
    pytest
  '';

  meta = {
    description = "Tools for Beam IO and Manipulation";
    homepage = http://radio-astro-tools.github.io;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}


