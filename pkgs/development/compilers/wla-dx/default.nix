{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "2019-03-10";
  name = "wla-dx-git-${version}";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    rev = "893102a51f916de429f1ef348bc9d1f5e022dee1";
    sha256 = "10nna00p0jsnx5cp6g8555ssszqznp5lqv5299cznjdhpjp9m27s";
  };

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    install binaries/* $out/bin
  '';

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://www.villehelin.com/wla.html;
    description = "Yet Another GB-Z80/Z80/6502/65C02/6510/65816/HUC6280/SPC-700 Multi Platform Cross Assembler Package";
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
