{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  name = "wla-dx-git-2016-02-27";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    rev = "8189fe8d5620584ea16563875ff3c5430527c86a";
    sha256 = "02zgkcyfx7y8j6jvyi12lm29fydnd7m3rxv6g2psv23fyzmpkkir";
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
    maintainers = with maintainers; [ mbauer ];
    platforms = platforms.all;
  };
}
