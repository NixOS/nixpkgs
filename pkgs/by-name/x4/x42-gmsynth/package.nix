{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  lv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x42-gmsynth";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "gmsynth.lv2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fu/wCQY5fTvAWo18hhiQC9LZAUwi3WJfhgWLI0rgmKs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    lv2
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Chris Colins' General User soundfont player LV2 plugin";
    homepage = "https://x42-plugins.com/x42/x42-gmsynth";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
