{
  lib,
  stdenv,
  fetchFromGitHub,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zapper";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "zapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8tkM3/hRSWwsgLiv9+n06INYpk6tz0hMZtOcOlQfLw=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  buildInputs = [ glibc.static ];

  buildFlags = [ "zapper" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 zapper $out/bin/zapper

    runHook postInstall
  '';

  meta = {
    description = "Zaps arguments and environment from the process list";
    homepage = "https://github.com/hackerschoice/zapper";
    changelog = "https://github.com/hackerschoice/zapper/releases/tag/${finalAttrs.src.tag}";
    # https://github.com/hackerschoice/zapper/issues/4
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zapper";
    platforms = lib.platforms.all;
  };
})
