{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "libedit-20090923-3.0";

  src = fetchurl {
    url = "http://www.thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "02j66qbd1c9wfghpjb8dzshkcj4i0n9xanxy81552j3is9ilxjka";
  };

  propagatedBuildInputs = [ ncurses ];

  meta = {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "A port of the NetBSD Editline library (libedit)";
  };
}
