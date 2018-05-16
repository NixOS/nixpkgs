{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dyncall-${version}";
  version = "1.0";

  src = fetchurl {
    url = http://www.dyncall.org/r1.0/dyncall-1.0.tar.gz;
    # http://www.dyncall.org/r1.0/SHA256
    sha256 = "d1b6d9753d67dcd4d9ea0708ed4a3018fb5bfc1eca5f37537fba2bc4f90748f2";
  };

  doCheck = true;
  checkTarget = "run-tests";

  meta = with stdenv.lib; {
    description = "Highly dynamic multi-platform foreign function call interface library";
    homepage = http://dyncall.org;
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
