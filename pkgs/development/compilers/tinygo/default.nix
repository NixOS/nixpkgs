{ lib, buildGoModule, fetchFromGitHub, llvm, clang-unwrapped, lld, avrgcc
, avrdude, openocd, gcc-arm-embedded, makeWrapper, fetchurl }:

let main = ./main.go;
    gomod = ./go.mod;
in
buildGoModule rec {
  pname = "tinygo";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "063aszbsnr0myq56kms1slmrfs7m4nmg0zgh2p66lxdsifrfly7j";
    fetchSubmodules = true;
  };

  overrideModAttrs = (_: {
      patches = [];
      preBuild = ''
      rm -rf *
      cp ${main} main.go
      cp ${gomod} go.mod
      chmod +w go.mod
      '';
  });

  preBuild = "cp ${gomod} go.mod";

  postBuild = "make gen-device";

  vendorSha256 = "12k2gin0v7aqz5543m12yhifc0xsz26qyqra5l4c68xizvzcvkxb";

  doCheck = false;

  prePatch = ''
    sed -i s/', "-nostdlibinc"'// builder/builtins.go
    sed -i s/'"-nostdlibinc", '// compileopts/config.go builder/picolibc.go
  '';

  subPackages = [ "." ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm clang-unwrapped ];
  propagatedBuildInputs = [ lld avrgcc avrdude openocd gcc-arm-embedded ];

  postInstall = ''
    mkdir -p $out/share/tinygo
    cp -a lib src targets $out/share/tinygo
    wrapProgram $out/bin/tinygo --prefix "TINYGOROOT" : "$out/share/tinygo" \
      --prefix "PATH" : "$out/libexec/tinygo"
    mkdir -p $out/libexec/tinygo
    ln -s ${clang-unwrapped}/bin/clang $out/libexec/tinygo/clang-10
    ln -s ${lld}/bin/lld $out/libexec/tinygo/ld.lld-10
    ln -sf $out/bin $out/share/tinygo
  '';

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chiiruno ];
  };
}
