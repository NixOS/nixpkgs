{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "expat-2.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "1wl1x93b5w457ddsdgj0lh7yjq4q6l7wfbgwhagkc8fm2qkkrd0p";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh
    patchShebangs ./test-driver-wrapper.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
