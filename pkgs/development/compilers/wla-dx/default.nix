{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "wla-dx";
  version = "9.11";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    rev = "v${version}-fix";
    sha256 = "0sz1vqafl7ii3z1710sk0ilvczv8pb4b6lkmg9pr7hqj3kaxndii";
  };

  installPhase = ''
    mkdir -p $out/bin
    install binaries/* $out/bin
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://www.villehelin.com/wla.html";
    description = "Yet Another GB-Z80/Z80/6502/65C02/6510/65816/HUC6280/SPC-700 Multi Platform Cross Assembler Package";
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
