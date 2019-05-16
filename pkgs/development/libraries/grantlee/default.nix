{ stdenv, fetchurl, qt4, cmake }:

stdenv.mkDerivation rec {
  name = "grantlee-0.5.1";

# Upstream download server has country code firewall, so I made a mirror.
  src = fetchurl {
    urls = [
      "http://downloads.grantlee.org/${name}.tar.gz"
      "http://www.loegria.net/grantlee/${name}.tar.gz"
    ];
    sha256 = "1b501xbimizmbmysl1j5zgnp48qw0r2r7lhgmxvzhzlv9jzhj60r";
  };

  buildInputs = [ cmake qt4 ];

  meta = {
    description = "Qt4 port of Django template system";
    longDescription = ''
      Grantlee is a plugin based String Template system written using the Qt
      framework. The goals of the project are to make it easier for application
      developers to separate the structure of documents from the data they
      contain, opening the door for theming.

      The syntax is intended to follow the syntax of the Django template system,
      and the design of Django is reused in Grantlee.'';

    homepage = http://gitorious.org/grantlee;
    license = stdenv.lib.licenses.lgpl21;
    inherit (qt4.meta) platforms;
  };
}
