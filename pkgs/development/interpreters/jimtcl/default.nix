{ stdenv, fetchgit, sqlite }:

stdenv.mkDerivation {
  name = "jimtcl-0.75-git";

  src = fetchgit {
    url = https://github.com/msteveb/jimtcl.git;
    rev = "c4d4bf8bc104733db1f5992a27d88fbfca9ba882";
    sha256 = "0vnl2k5sj250l08bplqd61zj6261v7kp202pss66g01rhp42fj3r";
  };

  buildInputs = [
    sqlite
  ];

  configureFlags = [
    "--with-ext=oo"
    "--with-ext=tree"
    "--with-ext=binary"
    "--with-ext=sqlite3"
    "--enable-utf8"
    "--ipv6"
  ];

  meta = {
    description = "An open source small-footprint implementation of the Tcl programming language";
    homepage = http://jim.tcl.tk/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ dbohdan ];
  };
}
