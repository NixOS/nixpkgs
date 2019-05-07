{ stdenv, fetchFromGitHub, libxml2, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "sierra-gtk-theme";
  version = "2019-05-07";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0rm9lcwp89ljxqrya9bi882qcs339pc1l945cr1xq2rganqyk9cq";
  };

  nativeBuildInputs = [ libxml2 ];

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh --dest $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A Mac OSX like theme for GTK based desktop environments";
    homepage = https://github.com/vinceliuice/Sierra-gtk-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
