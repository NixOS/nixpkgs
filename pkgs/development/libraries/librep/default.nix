{ stdenv, fetchurl
, pkgconfig, autoreconfHook
, readline, texinfo
, gdbm, gmp, libffi }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "librep-${version}";
  version = "0.92.6";
  sourceName = "librep_${version}";

  src = fetchurl {
    url = "http://download.tuxfamily.org/librep/${sourceName}.tar.xz";
    sha256 = "1k6c0hmyzxh8459r790slh9vv9vwy9d7w3nlmrqypbx9mk855hgy";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ readline texinfo ];
  propagatedBuildInputs = [ gdbm gmp libffi ];

  configureFlags = [
    "--disable-static"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Fast, lightweight, and versatile Lisp environment";
    longDescription = ''
      librep is a Lisp system for UNIX, comprising an
      interpreter, a byte-code compiler, and a virtual
      machine. It can serve as an application extension language
      but is also suitable for standalone scripts.
     '';
    homepage = http://sawfish.wikia.com;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
# TODO: investigate fetchFromGithub
