{
  lib,
  stdenv,
  fetchFromGitHub,
  mbuild,
  llvmPackages,
  installShellFiles,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xed";
  version = "2026.07.15";

  src = fetchFromGitHub {
    owner = "intelxed";
    repo = "xed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YpBDSkRKgL7KNpN9fLTiho4T6ntTV/4iK9EvXYckqvA=";
  };

  postPatch = ''
    patchShebangs mfile.py
  '';

  nativeBuildInputs = [
    mbuild
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.bintools ];

  buildPhase = ''
    runHook preBuild

    # this will build, test and install
    ./mfile.py test --prefix $out

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ./mfile.py examples

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    installBin obj/wkit/examples/obj/xed

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    broken = stdenv.hostPlatform.isAarch64;
    description = "Intel X86 Encoder Decoder (Intel XED)";
    homepage = "https://intelxed.github.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ arturcygan ];
  };
})
