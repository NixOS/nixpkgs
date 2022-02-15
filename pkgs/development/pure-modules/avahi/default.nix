{ lib, stdenv, fetchurl, pkg-config, pure, avahi }:

stdenv.mkDerivation rec {
  pname = "pure-avahi";
  version = "0.3";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-avahi-${version}.tar.gz";
    sha256 = "5fac8a6e3a54e45648ceb207ee0061b22eac8c4e668b8d53f13eb338b09c9160";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure avahi ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A digital audio interface for the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-avahi.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
