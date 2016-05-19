{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "expat-2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "0ryyjgvy7jq0qb7a9mhc1giy3bzn56aiwrs8dpydqngplbjq9xdg";
  };

  outputs = [ "dev" "out" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
