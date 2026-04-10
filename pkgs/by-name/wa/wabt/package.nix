{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wabt";
  version = "1.0.39";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wabt";
    tag = finalAttrs.version;
    hash = "sha256-Hwfk0wQ8Oz1XI/hIzVy0G+/FyWl+iiGYoFrgLbm27Tk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DCMAKE_PROJECT_VERSION=${finalAttrs.version}"
  ];

  meta = {
    description = "WebAssembly Binary Toolkit";
    longDescription = ''
      WABT (pronounced "wabbit") is a suite of tools for WebAssembly, including:
       * wat2wasm: translate from WebAssembly text format to the WebAssembly
         binary format
       * wasm2wat: the inverse of wat2wasm, translate from the binary format
         back to the text format (also known as a .wat)
       * wasm-objdump: print information about a wasm binary. Similiar to
         objdump.
       * wasm-interp: decode and run a WebAssembly binary file using a
         stack-based interpreter
       * wat-desugar: parse .wat text form as supported by the spec interpreter
         (s-expressions, flat syntax, or mixed) and print "canonical" flat
         format
       * wasm2c: convert a WebAssembly binary file to a C source and header
    '';
    homepage = "https://github.com/WebAssembly/wabt";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
