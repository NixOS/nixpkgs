{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "zafiro-icons";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0471gf4s32dhcm3667l1bnam04jk4miw3c6s557vix59rih1y71p";
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
