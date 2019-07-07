{stdenv, autoconf, automake, fetchFromGitHub, fetchpatch, glib, intltool, json_c, libtool, pkgconfig}:

let
  version = "1.3.0";
in stdenv.mkDerivation rec {
  name = "libmypaint-${version}";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "libmypaint";
    rev = "v${version}";
    sha256 = "0b7aynr6ggigwhjkfzi8x3dwz15blj4grkg9hysbgjh6lvzpy9jc";
  };

  patches = [
    # build with automake 1.16
    (fetchpatch {
      url = https://github.com/mypaint/libmypaint/commit/40d9077a80be13942476f164bddfabe842ab2a45.patch;
      sha256 = "1dclh7apgvr2bvzy9z3rgas3hk9pf2hpf5h52q94kmx8s4a47qpi";
    })
  ];

  nativeBuildInputs = [ autoconf automake intltool libtool pkgconfig ];

  buildInputs = [ glib ];

  propagatedBuildInputs = [ json_c ]; # for libmypaint.pc

  doCheck = true;

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = http://mypaint.org/;
    description = "Library for making brushstrokes which is used by MyPaint and other projects";
    license = licenses.isc;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
