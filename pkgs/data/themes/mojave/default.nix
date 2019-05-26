{ stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "mojave-gtk-theme";
  version = "2019-05-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "f6167740b308715b38567ec660aa5241d964af1b";
    sha256 = "1k57f5vimdrciskjgxqz7k0xybc7b8pwcsii0p6kc8klmyrjrr9c";
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
