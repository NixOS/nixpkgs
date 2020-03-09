{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "zafiro-icons";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = "${version}";
    sha256 = "0gy3c0jkj1icnwcs23b6km9cj9cccv8y5z1w11nfdv91cq3mdhmb";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons/Zafiro-icons
    cp -a * $out/share/icons/Zafiro-icons
    gtk-update-icon-cache "$out"/share/icons/Zafiro-icons
  '';

  meta = with stdenv.lib; {
    description = "Icon pack flat with light colors";
    homepage = https://github.com/zayronxio/Zafiro-icons;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
