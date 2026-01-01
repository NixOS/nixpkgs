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
<<<<<<< HEAD
  version = "4.4.18";
=======
  version = "4.4.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "KJ7LNW";
    repo = "xnec2c";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-bmbSuk/bgjLVs6IOIYpOTdeDCYKTZbsCgMv57cLKsEw=";
=======
    hash = "sha256-ZxKpClB5IBfcpIOJsGVSiZU8WGu/8Yzeru96uCKkCGQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
