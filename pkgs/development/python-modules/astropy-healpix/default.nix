{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "0.5";

  doCheck = false; # tests require pytest-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bfdq33mj6mwk5fkc6n23f9bc9z8j7kmvql3zchz4h58jskmvqas";
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
