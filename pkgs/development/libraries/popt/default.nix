{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "popt";
  version = "1.18";

  src = fetchurl {
    url = "mirror://debian/pool/main/p/popt/popt_${version}.orig.tar.gz";
    sha256 = "1lf5zlj5rbg6s4bww7hbhpca97prgprnarx978vcwa0bl81vqnai";
  };

  patches = lib.optionals stdenv.isCygwin [
    ./1.16-cygwin.patch
    ./1.16-vpath.patch
  ];

  doCheck = false; # fails

  meta = with lib; {
    description = "Command line option parsing library";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
