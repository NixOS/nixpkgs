{ lib, buildGoModule, fetchFromGitHub, llvm, clang-unwrapped, lld, avrgcc
, avrdude, openocd, gcc-arm-embedded, makeWrapper }:

buildGoModule rec {
  pname = "tinygo";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "0dw3kxf55p617pb0bj3knsqcfvap5scxlvhh3a9g9ia92kann4v1";
  };

  modSha256 = "1bjq4vaf38hi204lr9w3r3wcy1rzj06ygi5gzfa7dl3kx10hw6p0";
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
