{ stdenv, fetchurl, pkgconfig, pure, libxml2, libxslt }:

stdenv.mkDerivation rec {
  baseName = "xml";
  version = "0.7";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "e862dec060917a285bc3befc90f4eb70b6cc33136fb524ad3aa173714a35b0f7";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure libxml2 libxslt ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A simplified interface to the Gnome libxml2 and libxslt libraries for Pure";
    homepage = http://puredocs.bitbucket.org/pure-xml.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
