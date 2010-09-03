{ stdenv, fetchurl, qt4, cmake }:

stdenv.mkDerivation rec {
  name = "grantlee-0.1.5";

# Upstream download server has country code firewall, so I made a mirror. The
# URL of the mirror may change in the future, so don't publish it yet.
  src = fetchurl {
    urls = [
      "http://downloads.grantlee.org/${name}.tar.gz"
      "http://www.loegria.net/grantlee/${name}.tar.gz"
    ];
    sha256 = "040slr4kpi62vwkwnsxhvnq2m15wqn40knh69ci6kskmb3i8iv1a";
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
  };
}
