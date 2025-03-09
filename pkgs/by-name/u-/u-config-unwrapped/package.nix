{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u-config";
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2chZwS8aC7mbPJwsf5tju2ZNZNda650qT+ARjNJ2k2g=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    foundMakefile=1 # for checkPhase
    $CC -Os -o ${finalAttrs.meta.mainProgram} generic_main.c

    runHook postBuild
  '';

  installPhase =
    let
      binName = "${finalAttrs.meta.mainProgram}${stdenv.hostPlatform.extensions.executable}";
    in
    ''
      runHook preInstall

      install -Dm755 ${binName} -t $out/bin
      install -Dm644 u-config.1 $out/share/man/man1/u-config.1

      runHook postInstall
    '';

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Smaller, simpler, portable pkg-config clone";
    homepage = "https://github.com/skeeto/u-config";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
    mainProgram = "pkg-config";
  };
})
