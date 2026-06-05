{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thc-secure-delete";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gordrs";
    repo = "thc-secure-delete";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hvWuxFkzhOSCplPtyjRtn36bIk6KdPBcpr3lAmiAyfE=";
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/signal-handler-fix.patch?h=thc-secure-delete&id=ca83e2c6a548aaba56a0499180d15d61c75b6acd";
      hash = "sha256-MGCl5wXHuDr0Z4MlBGlSAUrv5VeQ8FjWCNsTOnS7Evw=";
      extraPrefix = "";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin/ -m755 srm sdmem sswap sfill
    installManPage *.1

    runHook postInstall
  '';

  meta = {
    description = "THC's Secure Delete tools";
    homepage = "https://github.com/gordrs/thc-secure-delete";
    changelog = "https://github.com/gordrs/thc-secure-delete/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "srm";
    platforms = lib.platforms.all;
  };
})
