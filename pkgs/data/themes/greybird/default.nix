{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, sassc, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "greybird";
  version = "3.22.13";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "154qawiga792iimkpk3a6q8f4gm4r158wmsagkbqqbhj33kxgxhg";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    sassc
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = with stdenv.lib; {
    description = "Grey and blue theme from the Shimmer Project for GTK-based environments";
    homepage = "https://github.com/shimmerproject/Greybird";
    license = [ licenses.gpl2Plus ]; # or alternatively: cc-by-nc-sa-30 or later
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
