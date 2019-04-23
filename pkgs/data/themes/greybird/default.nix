{ stdenv, fetchFromGitHub, autoreconfHook, which, sassc, glib, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "greybird";
  version = "3.22.10";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g1mnzxqwlbymq8npd2j294f8dzf9fw9nicd4pajmscg2vk71da9";
  };

  nativeBuildInputs = [
    autoreconfHook
    which
    sassc
    glib
    libxml2
  ];

  buildInputs = [
    gdk_pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  meta = with stdenv.lib; {
    description = "Grey and blue theme from the Shimmer Project for GTK+-based environments";
    homepage = https://github.com/shimmerproject/Greybird;
    license = with licenses; [ gpl2Plus ]; # or alternatively: cc-by-nc-sa-30
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
