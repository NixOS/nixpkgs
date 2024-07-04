{ lib
, fetchFromGitHub
, llvmPackages
, makeBinaryWrapper
, libiconv
, MacOSX-SDK
, Security
, which
}:

let
  inherit (llvmPackages) stdenv;
in stdenv.mkDerivation rec {
  pname = "odin";
  version = "dev-2024-06";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    rev = version;
    hash = "sha256-Ba+244L855y+XzLcaf1fgQhHVDv2Q77GPapRAYmCQfg=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper which
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/linker.cpp \
        --replace-fail '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk' ${MacOSX-SDK}
    '' + ''
    substituteInPlace build_odin.sh \
        --replace-fail '-framework System' '-lSystem'
    patchShebangs build_odin.sh
  '';

  dontConfigure = true;

  buildFlags = [
    "release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin

    mkdir -p $out/share
    cp -r base $out/share/base
    cp -r core $out/share/core
    cp -r vendor $out/share/vendor

    wrapProgram $out/bin/odin \
      --prefix PATH : ${lib.makeBinPath (with llvmPackages; [
        bintools
        llvm
        clang
        lld
      ])} \
      --set-default ODIN_ROOT $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast, concise, readable, pragmatic and open sourced programming language";
    mainProgram = "odin";
    homepage = "https://odin-lang.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r astavie znaniye ];
    platforms = platforms.x86_64 ++ [ "aarch64-darwin" ];
  };
}
