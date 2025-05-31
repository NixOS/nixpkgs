{
  stdenv,
  lib,
  fetchFromGitLab,
  nasm,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation {
  pname = "x264";
  version = "0-unstable-2025-01-03";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "x264";
    rev = "373697b467f7cd0af88f1e9e32d4f10540df4687";
    hash = "sha256-WWtS/UfKA4i1yakHErUnyT/3/+Wy2H5F0U0CmxW4ick=";
  };

  patches = [
    # Upstream ./configure greps for (-mcpu|-march|-mfpu) in CFLAGS, which in nix
    # is put in the cc wrapper anyway.
    ./disable-arm-neon-default.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile --replace '$(if $(STRIP), $(STRIP) -x $@)' '$(if $(STRIP), $(STRIP) -S $@)'
  '';

  enableParallelBuilding = true;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  preConfigure =
    lib.optionalString stdenv.hostPlatform.isx86 ''
      # `AS' is set to the binutils assembler, but we need nasm
      unset AS
    ''
    + lib.optionalString (stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isLoongArch64) ''
      export AS=$CC
    '';

  configureFlags =
    lib.optional enableShared "--enable-shared"
    ++ lib.optional (!stdenv.hostPlatform.isi686) "--enable-pic"
    ++ lib.optional (
      stdenv.buildPlatform != stdenv.hostPlatform
    ) "--cross-prefix=${stdenv.cc.targetPrefix}";

  makeFlags = [
    "BASHCOMPLETIONSDIR=$(out)/share/bash-completion/completions"
    "install-bashcompletion"
    "install-lib-shared"
  ];

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isx86 nasm;

  meta = with lib; {
    description = "Library for encoding H264/AVC video streams";
    mainProgram = "x264";
    homepage = "http://www.videolan.org/developers/x264.html";
    license = licenses.gpl2Plus;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = [ ];
  };
}
