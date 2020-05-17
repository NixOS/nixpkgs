{ stdenv, fetchFromGitHub, gdk-pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "canta-theme";
  version = "2020-05-17";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0b9ffkw611xxb2wh43sjqla195jp0ygxph5a8dvifkxdw6nxc2y0";
  };

  buildInputs = [ gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    install -D -t $out/share/backgrounds wallpaper/canta-wallpaper.svg
    rm $out/share/themes/*/{AUTHORS,COPYING}
  '';

  meta = with stdenv.lib; {
    description = "Flat Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Canta-theme";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
