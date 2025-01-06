{
  lib,
  stdenv,
  fetchFromGitHub,
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

  meta = with lib; {
    description = "THC's Secure Delete tools";
    homepage = "https://github.com/gordrs/thc-secure-delete";
    changelog = "https://github.com/gordrs/thc-secure-delete/blob/v${finalAttrs.version}/CHANGES";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "srm";
    platforms = platforms.all;
  };
})
