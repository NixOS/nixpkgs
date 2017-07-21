{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "2017-06-05";
  name = "wla-dx-git-${version}";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    rev = "ae6843f9711cbc2fa6dd8c200877b40bd2bcad7f";
    sha256 = "09c2kz12ld97ad41j6r8r65jknllrak1x8r43fgr26x7hdlxz5c6";
  };

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    install binaries/* $out/bin
  '';

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "http://www.villehelin.com/wla.html";
    description = "Yet Another GB-Z80/Z80/6502/65C02/6510/65816/HUC6280/SPC-700 Multi Platform Cross Assembler Package";
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
