{ stdenv
, lib
, fetchFromGitLab
, nasm
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "0-unstable-2023-10-01";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = "31e19f92f00c7003fa115047ce50978bc98c3a0d";
    hash = "sha256-7/FaaDFmoVhg82BIhP3RbFq4iKGNnhviOPxl3/8PWCM=";
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

  outputs = [ "out" "lib" "dev" ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isx86 ''
    # `AS' is set to the binutils assembler, but we need nasm
    unset AS
  '' + lib.optionalString stdenv.hostPlatform.isAarch ''
    export AS=$CC
  '';

  configureFlags = lib.optional enableShared "--enable-shared"
    ++ lib.optional (!stdenv.hostPlatform.isi686) "--enable-pic"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--cross-prefix=${stdenv.cc.targetPrefix}";

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
