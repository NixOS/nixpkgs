{ stdenv, fetchurl
, pkgconfig, autoreconfHook
, readline, texinfo
, gdbm, gmp, libffi }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "librep-${version}";
  version = "0.92.5";

  src = fetchurl {
    url = "https://github.com/SawfishWM/librep/archive/${name}.tar.gz";
    sha256 = "1ly425cgs0yi3lb5l84v3bacljw7m2nmzgky3acy1anp709iwi76";
  };

  buildInputs = [ pkgconfig autoreconfHook readline texinfo ];
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
