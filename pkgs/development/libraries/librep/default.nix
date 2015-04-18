
	{ stdenv, fetchgit
, pkgconfig, autoreconfHook
, readline, texinfo
, gdbm, gmp, libffi }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "librep-git-2015-02-15";

  src = fetchgit {
    url = "https://github.com/SawfishWM/librep.git";
    rev = "a1f2db721aa5055e90f6a76fde625946340ed8cf";
    sha256 = "c91484d02b2408becc8961997c3d6404aefa8e1f8af4621a8b5f7622b1857fa6";
  };

  buildInputs = [ pkgconfig autoreconfHook readline texinfo ];
  propagatedBuildInputs = [ gdbm gmp libffi ];

  configureFlags = [
    "--disable-static"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Lisp system for Sawfish";
    longDescription = ''
      This is librep, a Lisp system for UNIX, needed by Sawfish window manager.
      It contains a Lisp interpreter, byte-code compiler and virtual machine.
      Applications may use the Lisp interpreter as an extension language,
      or it may be used for stand-alone scripts.

      The Lisp dialect was originally inspired by Emacs Lisp, but with the worst
      features removed. It also borrows many ideas from Scheme.
    '';
    homepage = http://sawfish.wikia.com;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
