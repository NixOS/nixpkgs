{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xa";
  version = "2.4.1";

  src = fetchurl {
    urls = [
      "https://www.floodgap.com/retrotech/xa/dists/xa-${finalAttrs.version}.tar.gz"
      "https://www.floodgap.com/retrotech/xa/dists/unsupported/xa-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-Y8EqajKo42TzTwSdiyR39GVgIUGPCLjWtGK+DtO+OsM=";
  };

  nativeCheckInputs = [ perl ];

  dontConfigure = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CC = gcc" "CC = ${stdenv.cc.targetPrefix}cc" \
      --replace-fail "LD = gcc" "LD = ${stdenv.cc.targetPrefix}cc" \
      --replace-fail "CFLAGS = -O2" "CFLAGS ?=" \
      --replace-fail "LDFLAGS = -lc" "LDFLAGS ?= -lc" \
      --replace-fail "install: all" "install:"
  '';

  makeFlags = [ "DESTDIR:=${placeholder "out"}" ];

  enableParallelBuilding = true;

  doCheck = false; # while opening file: stat: No such file or directory [Makefile:21: test1.o65]

  # Running tests in parallel does not work
  enableParallelChecking = false;

  preCheck = ''
    patchShebangs tests
  '';

  meta = {
    homepage = "https://www.floodgap.com/retrotech/xa/";
    description = "Andre Fachat's open-source 6502 cross assembler";
    longDescription = ''
      xa is a high-speed, two-pass portable cross-assembler. It understands
      mnemonics and generates code for NMOS 6502s (such as 6502A, 6504, 6507,
      6510, 7501, 8500, 8501, 8502 ...), CMOS 6502s (65C02 and Rockwell R65C02)
      and the 65816.

      Key amongst its features:

      - C-like preprocessor (and understands cpp for additional feature support)
      - rich expression syntax and pseudo-op vocabulary
      - multiple character sets
      - binary linking
      - supports o65 relocatable objects with a full linker and relocation
        suite, as well as "bare" plain binary object files
      - block structure for label scoping
    '';
    mainProgram = "xa";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
