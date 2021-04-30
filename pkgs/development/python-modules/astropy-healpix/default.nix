{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "0.6";

  doCheck = false; # tests require pytest-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "409a6621c383641456c074f0f0350a24a4a58e910eaeef14e9bbce3e00ad6690";
  };

  propagatedBuildInputs = [ numpy astropy astropy-helpers ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  meta = with lib; {
    description = "BSD-licensed HEALPix for Astropy";
    homepage = "https://github.com/astropy/astropy-healpix";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
