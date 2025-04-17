{
  stdenv,
  lib,
  fetchFromGitLab,
  nasm,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    versionParts = lib.strings.splitString " " finalAttrs.version;

    versionNumberParts = lib.strings.splitString "." (lib.lists.head versionParts);
    # X264_BUILD in x264_config.h
    apiVersion = lib.lists.elemAt versionNumberParts 1;
    # X264_REV in x264_config.h
    numCommits = lib.lists.last versionNumberParts;

    gitRevision = lib.lists.last versionParts;
  in
  {
    pname = "x264";
    # X264_POINTVER in x264_config.h
    version = "0.164.3204 373697b";

    src = fetchFromGitLab {
      domain = "code.videolan.org";
      owner = "videolan";
      repo = "x264";
      rev = gitRevision;
      hash = "sha256-WWtS/UfKA4i1yakHErUnyT/3/+Wy2H5F0U0CmxW4ick=";
    };

    patches = [
      # Upstream ./configure greps for (-mcpu|-march|-mfpu) in CFLAGS, which in nix
      # is put in the cc wrapper anyway.
      ./disable-arm-neon-default.patch
    ];

    postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace Makefile --replace-fail \
        '$(if $(STRIP), $(STRIP) -x $@)' '$(if $(STRIP), $(STRIP) -S $@)'
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
      + lib.optionalString stdenv.hostPlatform.isAarch ''
        export AS=$CC
      '';

    configureFlags =
      lib.optional enableShared "--enable-shared"
      ++ lib.optional (!stdenv.hostPlatform.isi686) "--enable-pic"
      ++ lib.optional (
        stdenv.buildPlatform != stdenv.hostPlatform
      ) "--cross-prefix=${stdenv.cc.targetPrefix}";

    postConfigure = ''
      substituteInPlace x264_config.h --replace-fail \
        "X264_VERSION \"\"" "X264_VERSION \" r${numCommits} ${gitRevision}\""

      substituteInPlace x264_config.h --replace-fail \
        "X264_POINTVER \"0.${apiVersion}.x\"" "X264_POINTVER \"${finalAttrs.version}\""

      cat << EOF >> x264_config.h
      #define X264_REV ${numCommits}
      #define X264_REV_DIFF 0
      EOF
    '';

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
)
