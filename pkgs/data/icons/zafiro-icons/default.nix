{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "zafiro-icons";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = "v${version}";
    sha256 = "02q3wcklmqdy4ycyly7477q98y3mkgnpr7c78jqxvy2yr486wwyx";
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
