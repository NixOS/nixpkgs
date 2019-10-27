{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "0.4";

  doCheck = false; # tests require pytest-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c9709ac923759c92eca6d2e623e734d0f417eed40ba835b77d99dec09e51aa2";
  };

  propagatedBuildInputs = [ numpy astropy astropy-helpers ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  meta = with lib; {
    description = "BSD-licensed HEALPix for Astropy";
    homepage = https://github.com/astropy/astropy-healpix;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
