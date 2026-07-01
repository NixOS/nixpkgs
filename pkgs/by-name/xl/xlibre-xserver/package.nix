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
  libxext,
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
  libapplewm,
  darwin,
  enableGlx ? stdenv.hostPlatform.isLinux,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xlibre-xserver";
  version = "25.2.0";
  src = fetchFromGitHub {
    owner = "X11Libre";
    repo = "xserver";
    hash = "sha256-zyT7MyTMlVCodI6+GKVs1Z+pkWy6Rawpn0L6uJNgWfA=";
    tag = "xlibre-xserver-${finalAttrs.version}";
  };
  hardeningDisable = [
    "bindnow"
    "relro"
  ];
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ darwin.bootstrap_cmds ];

  buildInputs = [
    xorgproto
    libx11
    libxau
    libxext
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
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ libpciaccess ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ libapplewm ];

  mesonFlags = [
    (lib.mesonBool "glx" enableGlx)
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "-Dapple-applications-dir=${placeholder "out"}/Applications/Utilities"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    passthru.updateScript = nix-update-script { };
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
