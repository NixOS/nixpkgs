{ stdenv, fetchurl, qtbase, qtscript, cmake }:

stdenv.mkDerivation rec {
  name = "grantlee-5.0.0";

# Upstream download server has country code firewall, so I made a mirror.
  src = fetchurl {
    urls = [
      "http://downloads.grantlee.org/${name}.tar.gz"
      "http://www.loegria.net/grantlee/${name}.tar.gz"
    ];
    sha256 = "0qdifp1sg87j3869xva5ai2d6d5ph7z4b85wv1fypf2k5sljpwpa";
  };

  buildInputs = [ qtbase qtscript ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Qt5 port of Django template system";
    longDescription = ''
      Grantlee is a plugin based String Template system written using the Qt
      framework. The goals of the project are to make it easier for application
      developers to separate the structure of documents from the data they
      contain, opening the door for theming.

      The syntax is intended to follow the syntax of the Django template system,
      and the design of Django is reused in Grantlee.'';

    homepage = http://gitorious.org/grantlee;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (qtbase.meta) platforms;
  };
}
