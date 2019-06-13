{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "zafiro-icons";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zmnhih4gz8bidyzf1wimy85z7zx9i29mv1zirmykpqj819g7mx9";
  };

  nativeBuildInputs = [ gtk3 ];

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
