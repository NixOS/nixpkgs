{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2019-09-09";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1qffh6jsvy61f29ymw1v9hpjnsvhqin19mp05cys1lnwc7y810zr";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
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
