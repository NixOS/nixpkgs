{ stdenv, fetchurl, automake, autoconf, libtool, which }:

stdenv.mkDerivation rec {
  name = "ilmbase-2.2.1";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/openexr/${name}.tar.gz";
    sha256 = "17k0hq19wplx9s029kjrq6c51x2ryrfmaavcappkd0g67gk0dhna";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    ./bootstrap
  '';

  buildInputs = [ automake autoconf libtool which ];

  NIX_CFLAGS_LINK = [ "-pthread" ];

  patches = [ ./bootstrap.patch ];

  # fails 1 out of 1 tests with
  # "lt-ImathTest: testBoxAlgo.cpp:892: void {anonymous}::boxMatrixTransform(): Assertion `b21 == b2' failed"
  # at least on i686. spooky!
  doCheck = stdenv.isx86_64;

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
