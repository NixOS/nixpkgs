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

stdenv.mkDerivation rec {
  pname = "x42-avldrums";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "avldrums.lv2";
    tag = "v${version}";
    hash = "sha256-AZKHjzgw0TtLHh4TF+yOUSa+GlNVwyHCpJWAZikXTy4=";
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

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Drum sample player LV2 plugin dedicated to Glen MacArthur's AVLdrums";
    homepage = "https://x42-plugins.com/x42/x42-avldrums";
    maintainers = with maintainers; [
      magnetophon
    ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
