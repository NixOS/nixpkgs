{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2019-12-12";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0d5m9gh97db01ygqlp2sv9v1m183d9fgid9n9wms9r5rrrw6bs8m";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    name= ./install.sh -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Mac OSX Mojave like theme for GTK based desktop environments";
    homepage = https://github.com/vinceliuice/Mojave-gtk-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
