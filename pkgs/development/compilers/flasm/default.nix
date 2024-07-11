{ lib, stdenv, fetchzip, unzip, fetchpatch, bison, flex, gperf, zlib }:

stdenv.mkDerivation rec {
  pname = "flasm";
  version = "1.64";

  src = fetchzip {
    url = "https://www.nowrap.de/download/flasm16src.zip";
    sha256 = "03hvxm66rb6rjwbr07hc3k7ia5rim2xlhxbd9qmcai9xwmyiqafg";
    stripRoot = false;
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchains:
    #  https://sourceforge.net/p/flasm/patches/2/
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://sourceforge.net/p/flasm/patches/2/attachment/0001-flasm-fix-build-on-gcc-10-fno-common.patch";
      sha256 = "0ic7k1mmyvhpnxam89dbg8i9bfzk70zslfdxgpmkszx097bj1hv6";
    })
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  nativeBuildInputs = [ unzip bison flex gperf ];

  buildInputs = [ zlib ];

  installPhase = ''
    install -Dm755 flasm -t $out/bin
  '';

  meta = with lib; {
    description = "Assembler and disassembler for Flash (SWF) bytecode";
    mainProgram = "flasm";
    homepage = "https://flasm.sourceforge.net/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
