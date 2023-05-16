<<<<<<< HEAD
{ stdenv, lib, fetchFromGitHub, qtbase, cmake, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "grantlee";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "steveire";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-enP7b6A7Ndew2LJH569fN3IgPu2/KL5rCmU/jmKb9sY=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ qtbase ];

  meta = {
    description = "Libraries for text templating with Qt";
    longDescription = ''
      Grantlee is a set of Free Software libraries written using the Qt framework. Currently two libraries are shipped with Grantlee: Grantlee Templates and Grantlee TextDocument.
      The goal of Grantlee Templates is to make it easier for application developers to separate the structure of documents from the data they contain, opening the door for theming and advanced generation of other text such as code.
      The syntax uses the syntax of the Django template system, and the core design of Django is reused in Grantlee.
    '';

    homepage = "https://github.com/steveire/grantlee";
    license = lib.licenses.lgpl21Plus;
=======
{ lib, stdenv, fetchurl, qt4, cmake }:

stdenv.mkDerivation rec {
  pname = "grantlee";
  version = "0.5.1";

# Upstream download server has country code firewall, so I made a mirror.
  src = fetchurl {
    urls = [
      "http://downloads.grantlee.org/grantlee-${version}.tar.gz"
      "http://www.loegria.net/grantlee/grantlee-${version}.tar.gz"
    ];
    sha256 = "1b501xbimizmbmysl1j5zgnp48qw0r2r7lhgmxvzhzlv9jzhj60r";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 ];

  meta = {
    description = "Qt4 port of Django template system";
    longDescription = ''
      Grantlee is a plugin based String Template system written using the Qt
      framework. The goals of the project are to make it easier for application
      developers to separate the structure of documents from the data they
      contain, opening the door for theming.

      The syntax is intended to follow the syntax of the Django template system,
      and the design of Django is reused in Grantlee.'';

    homepage = "https://github.com/steveire/grantlee";
    license = lib.licenses.lgpl21;
    inherit (qt4.meta) platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
