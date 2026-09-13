{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  autoPatchelfHook,
  testers,
  tala,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tala";
  version = "0.4.3";
  strictDeps = true;
  __structuredAttrs = true;

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/terrastruct/TALA/releases/download/v${finalAttrs.version}/tala-v${finalAttrs.version}-linux-amd64.tar.gz";
        hash = "sha256-xc3ZVjK+dgyFRvMNhg7jWGmBgESPggl6WZB4NzclCiY=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/terrastruct/TALA/releases/download/v${finalAttrs.version}/tala-v${finalAttrs.version}-linux-arm64.tar.gz";
        hash = "sha256-Jo4ABZJIakGHQDgiM+uh08qnlAH1LjRGlhRdgvr3iU0=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/terrastruct/TALA/releases/download/v${finalAttrs.version}/tala-v${finalAttrs.version}-macos-amd64.tar.gz";
        hash = "sha256-IUUxkZXl5rZjlF02SSjo4Jh/jZa6zpo0wCY5fdX4LMg=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/terrastruct/TALA/releases/download/v${finalAttrs.version}/tala-v${finalAttrs.version}-macos-arm64.tar.gz";
        hash = "sha256-4dYb0jrSpwtG+tIypHFo/IK10hz+VydOAotgm5hdAiY=";
      };
    }
    .${stdenvNoCC.hostPlatform.system};

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

  dontBuild = true;
  dontStrip = stdenvNoCC.hostPlatform.isDarwin;

  unpackPhase = ''
    tar xf $src --strip-components=1 --exclude='._*'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/d2plugin-tala -t $out/bin/
    installManPage man/d2plugin-tala.1 man/tala.1

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = tala;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Proprietary layout engine plugin for D2";
    homepage = "https://d2lang.com/tour/tala/";
    changelog = "https://github.com/terrastruct/TALA/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "d2plugin-tala";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
