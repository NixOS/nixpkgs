{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cairo,
  glib,
  libGLU,
  lv2,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x42-avldrums";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "avldrums.lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9I/6zHISoH8+4NpASSyu6A5dSGtj+m7kc9NGp6KuIsI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    glib
    libGLU
    lv2
    pango
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Drum sample player LV2 plugin dedicated to Glen MacArthur's AVLdrums";
    homepage = "https://x42-plugins.com/x42/x42-avldrums";
    maintainers = with lib.maintainers; [
      magnetophon
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
