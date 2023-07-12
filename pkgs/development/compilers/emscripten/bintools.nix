{ emscripten
, stdenvNoCC
, lib
, makeWrapper
, wasmArch ? if stdenvNoCC.targetPlatform.isWasm
  then stdenvNoCC.targetPlatform.uname.processor
  else "wasm32"
, wrapBintoolsWith
}:

let
  stdenv = stdenvNoCC;
  targetPrefix = "${wasmArch}-emscripten-";
  llvm = emscripten.llvmEnv;

  unwrapped = stdenv.mkDerivation {
    pname = "${wasmArch}-emscripten-bintools";
    version = emscripten.version;

    preferLocalBuild = true;

    passthru = {
      libc_bin = null;
      libc_dev = null;
      libc_lib = null;
      nativeTools = false;
      nativeLibc = false;
      nativePrefix = "";
    };

    dontBuild = true;
    dontConfigure = true;
    enableParallelBuilding = true;

    nativeBuildInputs = [ makeWrapper ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/nix-support

      makeWrapper ${emscripten}/bin/emar $out/bin/ar
      makeWrapper ${emscripten}/bin/emranlib $out/bin/ranlib
      makeWrapper ${emscripten}/bin/emsize $out/bin/size

      lnLLVM () { ln -s ${llvm}/bin/$1 $out/bin/$2; }
      lnLLVM llvm-objdump objdump
      lnLLVM llvm-objcopy objcopy
      lnLLVM llvm-strings strings
      lnLLVM llvm-as as
      lnLLVM llvm-nm nm
      lnLLVM llvm-cxxfilt c++filt
      lnLLVM llvm-addr2line addr2line

      runHook postInstall
    '';

    meta = emscripten.meta // (with lib; {
      description = "Lightweight Emscripten wrapper that can be bintools-wrapped";
      maintainers = with maintainers; [ atnnn ];
    });
  };

in
wrapBintoolsWith { bintools = unwrapped; }
