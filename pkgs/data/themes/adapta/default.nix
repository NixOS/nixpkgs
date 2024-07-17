{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  parallel,
  sassc,
  inkscape,
  libxml2,
  glib,
  gdk-pixbuf,
  librsvg,
  gtk-engine-murrine,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "adapta-gtk-theme";
  version = "3.95.0.11";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-gtk-theme";
    rev = version;
    sha256 = "19skrhp10xx07hbd0lr3d619vj2im35d8p9rmb4v4zacci804q04";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    parallel
    sassc
    inkscape
    libxml2
    glib.dev
    gnome.gnome-shell
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags = [
    "--disable-gtk_legacy"
    "--disable-gtk_next"
    "--disable-unity"
  ];

  meta = with lib; {
    description = "An adaptive GTK theme based on Material Design Guidelines";
    homepage = "https://github.com/adapta-project/adapta-gtk-theme";
    license = with licenses; [
      gpl2
      cc-by-sa-30
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
