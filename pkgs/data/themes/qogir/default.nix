{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "qogir-theme";
  version = "2019-05-03";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "031nqr47b3x8ahcym7cfc75y8sy53dcmrrrlywi7m1a10ckfp0pd";
  };

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./Install -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A flat Design theme for GTK based desktop environments";
    homepage = https://vinceliuice.github.io/Qogir-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
