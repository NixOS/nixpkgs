{ stdenv, fetchFromGitHub, libxml2, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "sierra-gtk-theme";
  version = "2019-12-16";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "14hlz8kbrjypyd6wyrwmnj2wm9w3kc8y00ms35ard7x8lmhs56hr";
  };

  nativeBuildInputs = [ libxml2 ];

  buildInputs = [ gdk-pixbuf librsvg ];

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
