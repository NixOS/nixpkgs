{ lib, buildGoModule, fetchFromGitHub, llvm, clang-unwrapped, lld, avrgcc
, avrdude, openocd, gcc-arm-embedded, makeWrapper }:

buildGoModule rec {
  pname = "tinygo";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "0cmg8x9hpvzlxp6hiy9hkh9nn7ig7b0x6k8a2c3bw19pfx9lxksf";
  };

  modSha256 = "0r3lfi1bj550sf3b7ysz62c2c33f8zfli8208xixj3jadycb6r3z";
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
