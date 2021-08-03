{ stdenv
, fetchFromGitHub
, glib
, lib
}:

stdenv.mkDerivation rec {
  pname = "flat-remix-gnome";
  version = "20210716";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    hash = "sha256-UAWi4MyqtuSzp5TEkVLYJF7+2tzH/aT60ObNOimCJ4o=";
  };

  nativeBuildInputs = [ glib ];
  makeFlags = [ "PREFIX=$(out)" ];
  preInstall = ''
    # make install will back up this file, it will fail if the file doesn't exist.
    # https://github.com/daniruiz/flat-remix-gnome/blob/20210716/Makefile#L53
    mkdir -p $out/share/gnome-shell/
    touch $out/share/gnome-shell/gnome-shell-theme.gresource
  '';

  postInstall = ''
    rm $out/share/gnome-shell/gnome-shell-theme.gresource.old
  '';

  meta = with lib; {
    description = "GNOME Shell theme inspired by material design.";
    homepage = "https://drasite.com/flat-remix-gnome";
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
    maintainers = [ maintainers.vanilla ];
  };
}
