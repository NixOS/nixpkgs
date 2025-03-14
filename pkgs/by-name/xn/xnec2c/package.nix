{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wrapGAppsHook3,
  pkg-config,
  which,
  gtk3,
  blas,
  lapack,
  nix-update-script,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "xnec2c";
  version = "4.4.16";

  src = fetchFromGitHub {
    owner = "KJ7LNW";
    repo = "xnec2c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W8JwbCSXt5cjgncOzV1wltPnJxwWC6B29eaT8emIU9Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook3
    pkg-config
    which
  ];
  buildInputs = [
    gtk3
    blas
    lapack
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.xnec2c.org/";
    description = "Graphical antenna simulation";
    mainProgram = "xnec2c";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = lib.platforms.unix;

    # Darwin support likely to be fixed upstream in the next release
    broken = stdenv.hostPlatform.isDarwin;
  };
})
