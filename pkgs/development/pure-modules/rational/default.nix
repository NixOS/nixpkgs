{ lib, stdenv, fetchurl, pkg-config, pure }:

stdenv.mkDerivation rec {
  pname = "pure-rational";
  version = "0.1";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-rational-${version}.tar.gz";
    sha256 = "62cb4079a0dadd232a859e577e97e50e9718ccfcc5983c4d9c4c32cac7a9bafa";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A collection of utility functions for rational numbers, and a module for doing interval arithmetic in Pure";
    homepage = "http://puredocs.bitbucket.org/pure-rational.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
