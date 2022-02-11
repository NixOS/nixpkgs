{ lib, stdenv, fetchurl, pkg-config, pure, libxml2, libxslt }:

stdenv.mkDerivation rec {
  pname = "pure-xml";
  version = "0.7";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-xml-${version}.tar.gz";
    sha256 = "e862dec060917a285bc3befc90f4eb70b6cc33136fb524ad3aa173714a35b0f7";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure libxml2 libxslt ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A simplified interface to the Gnome libxml2 and libxslt libraries for Pure";
    homepage = "http://puredocs.bitbucket.org/pure-xml.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
