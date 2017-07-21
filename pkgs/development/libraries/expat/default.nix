{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "expat-2.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "0ik0r39ala9c6hj4kxrk933klgwkzlkbrfhvhaykx8l1rwgr2xj3";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true;

  preCheck = "patchShebangs ./run.sh";

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
