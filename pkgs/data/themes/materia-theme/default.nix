{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, sassc
, gnome
, gtk-engine-murrine
, gdk-pixbuf
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "materia-theme";
  version = "20210322";

  src = fetchFromGitHub {
    owner = "nana-4";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fsicmcni70jkl4jb3fvh7yv0v9jhb8nwjzdq8vfwn256qyk0xvl";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  buildInputs = [ gnome.gnome-themes-extra gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  mesonFlags = [
    "-Dgnome_shell_version=${lib.versions.majorMinor gnome.gnome-shell.version}"
  ];

  postInstall = ''
    rm $out/share/themes/*/COPYING
  '';

  meta = with lib; {
    description = "Material Design theme for GNOME/GTK based desktop environments";
    homepage = "https://github.com/nana-4/materia-theme";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.mounium ];
  };
}
