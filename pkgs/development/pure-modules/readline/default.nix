{ lib, stdenv, fetchurl, pkg-config, pure, readline }:

stdenv.mkDerivation rec {
  pname = "pure-readline";
  version = "0.3";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-readline-${version}.tar.gz";
    sha256 = "db8e6663b1c085466c09662fe86d952b6f4ffdafeecffe805c681ab91c910886";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure readline ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A trivial wrapper around GNU readline, which gives Pure scripts access to the most important facilities of the readline interface";
    homepage = "http://puredocs.bitbucket.org/pure-readline.html";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
