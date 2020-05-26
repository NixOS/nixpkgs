{ lib, buildGoModule, fetchFromGitHub, llvm, clang-unwrapped, lld, avrgcc
, avrdude, openocd, gcc-arm-embedded, makeWrapper }:

buildGoModule rec {
  pname = "tinygo";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "0x59j56y704m2hfkg78illgw9f6czrx265x887jfd989lnxphyqa";
  };

  modSha256 = "0y8n4mcr4jhas29ahvk8k4zbj1iz65fdpsgq61qa8kcsm8m5kqa6";
  enableParallelBuilding = true;
  subPackages = [ "." ];
  buildInputs = [ llvm clang-unwrapped makeWrapper ];
  propagatedBuildInputs = [ lld avrgcc avrdude openocd gcc-arm-embedded ];

  postInstall = ''
    mkdir -p $out/share/tinygo
    cp -a lib src targets $out/share/tinygo
    wrapProgram $out/bin/tinygo --prefix "TINYGOROOT" : "$out/share/tinygo"
    ln -sf $out/bin $out/share/tinygo
  '';

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
