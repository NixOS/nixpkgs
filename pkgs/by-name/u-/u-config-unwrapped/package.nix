{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u-config";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "u-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r1zcXKLqw/gK+9k3SX7OCBaZhvV2ya5VC9O3h+WdkyY=";
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
