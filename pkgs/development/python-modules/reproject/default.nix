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
  version = "0.5.1";

  doCheck = false; # tests require pytest-astropy

  src = fetchPypi {
    inherit pname version;
    sha256 = "069rha55cbm8vsi1qf8zydds42lgkcc97sd57hmjw1mgiz025xrp";
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
