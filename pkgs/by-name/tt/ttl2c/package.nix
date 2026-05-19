{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  lv2,
  python3,
  wafHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ttl2c";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lvtk";
    repo = "ttl2c";
    rev = "b64e425f38399a0d18d1252694d6d6980c800841";
    hash = "sha256-Vy3UoMnr9SIMw0pZfyuLjDHf/Gzgn5g3V0fGTIypQyM=";
  };

  # remove outdated vendored waf
  postPatch = ''
    rm waf
  '';

  nativeBuildInputs = [
    python3
    wafHook
  ];

  buildInputs = [
    boost
    lv2
  ];

  enableParallelBuilding = true;

  meta = {
    description = "C header generator for LV2 plugins";
    mainProgram = "ttl2c";
    homepage = "https://lvtk.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bot-wxt1221
      fliegendewurst
    ];
    platforms = lib.platforms.unix;
    badPlatforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
