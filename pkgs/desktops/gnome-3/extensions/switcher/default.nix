{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-switcher";
  version = "26";

  src = fetchFromGitHub {
    owner = "daniellandau";
    repo = "switcher";
    rev = "b707bdfcfaac9bf6e73e162ab75b871eb920ae41";
    sha256 = "1hx078w8mzaflwk8kd7s8np4041mbgca86rg7iyb9g8wbrbb0nzv";
  };

  uuid = "switcher@landau.fi";

  nativeBuildInputs = [ glib ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}/
  '';

  meta = with stdenv.lib; {
    description = "Gnome Shell extension for switching windows by typing";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ danieldk ];
    homepage = "https://github.com/daniellandau/switcher";
  };
}
