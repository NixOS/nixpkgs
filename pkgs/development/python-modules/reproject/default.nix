{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, numpy
, astropy
, astropy-healpix
, astropy-helpers
, astropy-extension-helpers
, scipy
, pytest
, pytest-astropy
, setuptools-scm
, cython
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jsc3ad518vyys5987fr1achq8qvnz8rm80zp5an9qxlwr4zmh4m";
  };

  patches = [ (fetchpatch {
      # Can be removed in next release after 0.7.1
      # See https://github.com/astropy/reproject/issues/246
      url = "https://github.com/astropy/reproject/pull/243.patch";
      sha256 = "0dq3ii39hsrks0b9v306dlqf07dx0hqad8rwajmzw6rfda9m3c2a";
    })
  ];

  propagatedBuildInputs = [ numpy astropy astropy-healpix astropy-helpers scipy ];
  nativeBuildInputs = [ astropy-helpers cython astropy-extension-helpers setuptools-scm ];
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
