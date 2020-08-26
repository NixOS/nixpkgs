{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, sassc, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "greybird";
  version = "3.22.12";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j66ddvl3pmwh2v8ajm8r5g5nbsr7r262ff1qn2nf3i0gy8b3lq8";
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
