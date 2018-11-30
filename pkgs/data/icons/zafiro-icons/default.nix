{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "zafiro-icons";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rs3wazmvidlkig5q7x1n9nz7jhfq18wps3wsplax9zcdy0hv248";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons/Zafiro
    cp -a * $out/share/icons/Zafiro
    gtk-update-icon-cache "$out"/share/icons/Zafiro
  '';

  meta = with stdenv.lib; {
    description = "Icon pack flat with light colors";
    homepage = https://github.com/zayronxio/Zafiro-icons;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
