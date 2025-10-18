{
  lib,
  stdenv,
  fetchurl,
  libX11,
  glib,
  pkg-config,
  libXmu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmctrl";
  version = "1.07";

  src = fetchurl {
    url = "https://web.archive.org/web/20221116231622/http://tripie.sweb.cz/utils/wmctrl/dist/wmctrl-${finalAttrs.version}.tar.gz";
    hash = "sha256-RW/cIbA0w1UuRNDEvrljAkuKMqpdqf3996oUNSE6kx8=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ glib.dev ];
  buildInputs = [
    libX11
    libXmu
    glib
  ];

  patches = [ ./64-bit-data.patch ];

  meta = {
    homepage = "https://web.archive.org/web/20221116231622/http://tripie.sweb.cz/utils/wmctrl/";
    description = "CLI tool to interact with EWMH/NetWM compatible X Window Managers";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; all;
    maintainers = [ lib.maintainers.Anton-Latukha ];
    mainProgram = "wmctrl";
  };
})
