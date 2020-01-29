{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, sassc, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "greybird";
  version = "3.22.11";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "00x7dcjldph9k0nmvc8hyh3k4lhbmwk791rywd89ry6jivrx40pc";
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
