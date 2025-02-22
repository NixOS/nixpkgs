{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u-config";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T0reHSgPmX+fhiL+6whqQFIg3etfYveYc4WA9z7Oh7Q=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

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

  meta = {
    description = "Smaller, simpler, portable pkg-config clone";
    homepage = "https://github.com/skeeto/u-config";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
    mainProgram = "pkg-config";
  };
})
