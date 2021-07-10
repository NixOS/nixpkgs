{ lib, buildGoModule, fetchFromGitHub, makeWrapper
, llvm, clang-unwrapped, lld, avrgcc, go, gcc-arm-embedded
, avrdude, openocd }:

buildGoModule rec {
  pname = "tinygo";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v3k9pinwy6d4xwlzgnisj2lmmgl5kfk2hwmfcggqxxrpr3ppaw8";
    fetchSubmodules = true;
  };

  vendorSha256 = "0dmy1g6w7awf807qf4mw67lmp6hkzbzx1a6il59wrx442rsz5l1b";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm clang-unwrapped ];
  propagatedBuildInputs = [
    clang-unwrapped lld avrgcc avrdude
    openocd gcc-arm-embedded
  ];

  # We need to set GOROOT to import and compile
  # standard go libraries with tinygo
  allowGoReference = true;

  prePatch = ''
    patchShebangs lib/wasi-libc
    sed -i s/', "-nostdlibinc"'// builder/builtins.go
    sed -i s/'"-nostdlibinc", '// compileopts/config.go builder/picolibc.go
  '';

  postBuild = ''
    make gen-device
  '';

  postInstall = ''
    mkdir -p $out/share/tinygo
    cp -a lib src targets $out/share/tinygo
  '';

  postFixup = ''
    wrapProgram $out/bin/tinygo \
      --prefix "TINYGOROOT" : $out/share/tinygo \
      --prefix "GOROOT" : ${go}/share/go \
  '';

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chiiruno ];
  };
}
