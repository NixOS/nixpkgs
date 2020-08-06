{ lib, buildGoModule, fetchFromGitHub, llvm, clang-unwrapped, lld, avrgcc
, avrdude, openocd, gcc-arm-embedded, makeWrapper, fetchurl }:

let main = ./main.go;
    gomod = ./go.mod;
in
buildGoModule rec {
  pname = "tinygo";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "1shvqqyxhaffbwakh48ma3hwj39phw06ylqap53pwqcpv970czsm";
    fetchSubmodules = true;
  };

  overrideModAttrs = (_: {
      patches = [];
      preBuild = ''
      rm -rf *
      cp ${main} main.go
      cp ${gomod} go.mod
      '';
  });

  preBuild = "cp ${gomod} go.mod";

  vendorSha256 = "19194dlzpl6zzw2gqybma5pwip71rw8z937f104k6c158qzzgy62";
  enableParallelBuilding = true;
  subPackages = [ "." ];
  buildInputs = [ llvm clang-unwrapped makeWrapper ];
  propagatedBuildInputs = [ lld avrgcc avrdude openocd gcc-arm-embedded ];

  postInstall = ''
    mkdir -p $out/share/tinygo
    make gen-device
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
