{ buildPythonPackage, isPy3k, fetchFromGitHub, stdenv,
  netcdf, hdf5, libminc, ezminc,
  cython, numpy, scipy
}:

buildPythonPackage rec {
  pname = "pyezminc";
  version = "1.2.01";
 
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = "pyezminc";
    rev    = "release-${version}";
    sha256 = "13smvramacisbwj8qsl160dnvv6ynngn1jmqwhvy146nmadphyv1";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ netcdf hdf5 libminc ezminc ];
  propagatedBuildInputs = [ numpy scipy ];

  NIX_CFLAGS_COMPILE = "-fpermissive";

  doCheck = false;  # e.g., expects test data in /opt

  meta = {
    homepage = https://github.com/BIC-MNI/pyezminc;
    description = "Python API for libminc using EZMINC";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ bcdarwin ];
    broken = true;
  };
}
