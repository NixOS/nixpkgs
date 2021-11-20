{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, llvm
, clang-unwrapped
, lld
, avrgcc
, go
, gcc-arm-embedded
, avrdude
, openocd
}:

let
  llvmMajor = lib.versions.major llvm.version;
in buildGoModule rec {
  pname = "tinygo";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZAUvOKApwOIKWINta9jEs/M32pHgW86+a0Y1jHEMupk=";
    fetchSubmodules = true;
  };

  vendorSha256 = "sha256-fD9/hPRXIT7cPljA+QNWDRESqHXeCbtWHMq12280R1g=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm clang-unwrapped ];

  subPackages = [ "." ];

  doCheck = false;

  # We need to set GOROOT to import and compile
  # standard go libraries with tinygo
  allowGoReference = true;

  postPatch = ''
    patchShebangs lib/wasi-libc
    sed -i s/', "-nostdlibinc"'// builder/builtins.go
    sed -i s/'"-nostdlibinc", '// compileopts/config.go builder/picolibc.go
  '';

  postBuild = ''
    make gen-device
  '';

  postInstall = ''
    mkdir -p $out/share/tinygo $out/libexec/tinygo
    cp -a lib src targets $out/share/tinygo

    ln -s ${lib.getBin clang-unwrapped}/bin/clang $out/libexec/tinygo/clang-${llvmMajor}
    ln -s ${lib.getBin lld}/bin/ld.lld $out/libexec/tinygo/ld.lld-${llvmMajor}
    ln -s ${lib.getBin lld}/bin/wasm-ld $out/libexec/tinygo/wasm-ld-${llvmMajor}
  '';

  postFixup = ''
    wrapProgram $out/bin/tinygo \
      --prefix PATH : ${lib.makeBinPath [ avrgcc avrdude openocd gcc-arm-embedded ]}:$out/libexec/tinygo \
      --prefix TINYGOROOT : $out/share/tinygo \
      --prefix GOROOT : ${go.outPath}/share/go
  '';

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ chiiruno musfay ];
  };
}
