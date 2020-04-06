{ stdenv, fetchurl, pkgconfig, pure, readline }:

stdenv.mkDerivation rec {
  baseName = "readline";
  version = "0.3";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "db8e6663b1c085466c09662fe86d952b6f4ffdafeecffe805c681ab91c910886";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure readline ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A trivial wrapper around GNU readline, which gives Pure scripts access to the most important facilities of the readline interface";
    homepage = http://puredocs.bitbucket.org/pure-readline.html;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
