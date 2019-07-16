{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-healpix
, astropy-helpers
, scipy
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.4";

  doCheck = false; # tests require pytest-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbbb18a8b211292c7ce61121b8538fc279540337be1c05cabc7570c5aca6d734";
  };

  propagatedBuildInputs = [ numpy astropy astropy-healpix astropy-helpers scipy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  meta = with lib; {
    description = "Reproject astronomical images";
    homepage = https://reproject.readthedocs.io;
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
