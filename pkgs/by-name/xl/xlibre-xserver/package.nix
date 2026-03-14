{
  lib,
  nix-update-script,
  stdenv,
  meson,
  ninja,
  pkg-config,
  fetchFromGitHub,
  xorgproto,
  libx11,
  libxau,
  libxcb,
  libxcb-util,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxdmcp,
  libxfixes,
  libxkbfile,
  libxfont_2,
  libxcvt,
  pixman,
  testers,
  openssl,
  libGL,
  libepoxy,
  libpciaccess,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xlibre-xserver";
  version = "25.1.2";
  src = fetchFromGitHub {
    owner = "X11Libre";
    repo = "xserver";
    hash = "sha256-Egfno6SfYE6fCqI993ZYLFGp+NmotgyiK8iCvkTQ6zU=";
    tag = "xlibre-xserver-${finalAttrs.version}";
  };
  hardeningDisable = [
    "bindnow"
    "relro"
  ];
  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    xorgproto
    libx11
    libxau
    libxcb
    libxcb-util
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxdmcp
    libxfixes
    libxkbfile
    libxfont_2
    libxcvt
    pixman
    openssl
    libGL
    libepoxy
    libpciaccess
  ];
  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };
  meta = {
    description = "X server implementation by X11Libre";
    homepage = "https://github.com/X11Libre/xserver";
    license = [
      lib.licenses.x11
      lib.licenses.mit
      lib.licenses.hpndSellVariant
      lib.licenses.mitOpenGroup
      lib.licenses.hpnd
      lib.licenses.dec3Clause
      lib.licenses.x11NoPermitPersons
      lib.licenses.sgi-b-20
      lib.licenses.bsd3
      lib.licenses.adobeDisplayPostScript
      lib.licenses.ntp
      lib.licenses.hpndUc
      lib.licenses.isc
      lib.licenses.icu
      lib.licenses.hpndSellVariantMitDisclaimerXserver
    ];
    mainProgram = "X";
    maintainers = [ lib.maintainers.theoparis ];
    pkgConfigModules = [ "xorg-server" ];
    platforms = lib.platforms.unix;
  };
})
