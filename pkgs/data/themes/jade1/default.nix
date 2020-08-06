{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "theme-jade1";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "theme-jade-1";
    rev = "v${version}";
    sha256 = "1nvn2ghkdhilrsjpvl7r92aldvbs0nx0xc82jwrfaahi87dgfs8x";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Jade* $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Based on Linux Mint theme with dark menus and more intensive green";
    homepage = "https://github.com/madmaxms/theme-jade-1";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
