{ lib, stdenv, fetchurl, pkg-config, pure }:

stdenv.mkDerivation rec {
  pname = "pure-sockets";
  version = "0.7";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-sockets-${version}.tar.gz";
    sha256 = "4f2769618ae5818cf6005bb08bcf02fe359a2e31998d12dc0c72f0494e9c0420";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A Pure interface to the Berkeley socket functions";
    homepage = "http://puredocs.bitbucket.org/pure-sockets.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
