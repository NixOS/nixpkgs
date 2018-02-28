{ stdenv, fetchFromGitHub, gtk3, papirus-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-icon-theme";
  version = "15.12.52";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "141in9jlflmckd8rg4605dfks84p1p6b1zdbhbiwrg11xbl66f3l";
    
    # Get rid of case collision in file names, which is an issue in
    # darwin where file names are case insensitive.
    extraPostFetch = ''
      rm "$out"/Sea/apps/scalable/TeXmacs.svg
      rm "$out"/deepin/apps/48/TeXmacs.svg
    ''; 
  };

  nativeBuildInputs = [ gtk3 papirus-icon-theme ];

  makeFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Deepin icon theme";
    homepage = https://github.com/linuxdeepin/deepin-icon-theme;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
