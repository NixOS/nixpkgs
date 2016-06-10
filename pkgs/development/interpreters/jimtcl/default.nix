{ stdenv, fetchgit, sqlite }:

stdenv.mkDerivation {
  name = "jimtcl-0.75-git";

  src = fetchgit {
    url = https://github.com/msteveb/jimtcl.git;
    rev = "c4d4bf8bc104733db1f5992a27d88fbfca9ba882";
    sha256 = "1dm1qmb35hlp0d4i15c78n8jmbv7nhz2cgbrjyn6fjy6cy67sq0r";
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
