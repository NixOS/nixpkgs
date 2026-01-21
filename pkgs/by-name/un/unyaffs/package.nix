{
  fetchFromGitHub,
  lib,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unyaffs";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "whataday";
    repo = "unyaffs";
    rev = "${finalAttrs.version}";
    hash = "sha256-FcuPaxq74gVJ6UlOhFPSMtuwUAJVV/sAxAQojhmVXCs=";
  };

  preBuild = ''
    sed -i '54i #if defined(__linux__)' unyaffs.c
    sed -i '55i #include <sys/sysmacros.h>' unyaffs.c
    sed -i '56i #endif' unyaffs.c
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 unyaffs -t $out/bin

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-V";

  meta = {
    description = "Tool to extract files from a YAFFS2 file system image";
    homepage = "https://github.com/whataday/unyaffs";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "unyaffs";
  };
})
