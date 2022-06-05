{ stdenv, fetchFromGitLab, pkg-config, gtk3, intltool, autoreconfHook, fetchpatch
, GConf, enchant, isocodes, gnome-icon-theme, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  version = "4.10.0";
  pname = "gtkhtml";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gtkhtml";
    rev = "master";
    sha256 = "sha256-jL8YADvhW0o6I/2Uo5FNARMAnSbvtmFp+zWH1yCVvQk=";
  };

  patches = [
    # Enables enchant2 support.
    # Upstream is dead, no further releases are coming.
    (fetchpatch {
      name ="enchant-2.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/enchant-2.patch?h=gtkhtml4&id=0218303a63d64c04d6483a6fe9bb55063fcfaa43";
      sha256 = "f0OToWGHZwxvqf+0qosfA9FfwJ/IXfjIPP5/WrcvArI=";
      extraPrefix = "";
    })
  ];

  propagatedBuildInputs = [ gsettings-desktop-schemas gtk3 gnome-icon-theme GConf ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool enchant isocodes autoreconfHook ];
}
