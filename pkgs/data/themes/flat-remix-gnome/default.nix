{
  stdenv,
  fetchFromGitHub,
  glib,
  lib,
  writeScriptBin,
}:
let
  # make install will use dconf to find desktop background file uri.
  # consider adding an args to allow specify pictures manually.
  # https://github.com/daniruiz/flat-remix-gnome/blob/20240503/Makefile#L38
  fake-dconf = writeScriptBin "dconf" "echo -n";
in
stdenv.mkDerivation rec {
  pname = "flat-remix-gnome";
  version = "20240503";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    hash = "sha256-02hYxgq8Go++oYT8r86wA7HVXQJeUZ0JpwIu3VWfjQE=";
  };

  nativeBuildInputs = [
    glib
    fake-dconf
  ];
  makeFlags = [ "PREFIX=$(out)" ];

  # make install will back up this file, it will fail if the file doesn't exist.
  # https://github.com/daniruiz/flat-remix-gnome/blob/20240503/Makefile#L56
  preInstall = ''
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
