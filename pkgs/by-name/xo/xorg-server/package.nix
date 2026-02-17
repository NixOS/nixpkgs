{
  lib,
  stdenv,
  fetchurl,

  # build system
  meson,
  ninja,
  pkg-config,

  # deps
  dbus,
  dri-pkgconfig-stub,
  font-util,
  libdrm,
  libepoxy,
  libgbm,
  libGL,
  libGLU,
  libpciaccess,
  libtirpc,
  libunwind,
  libx11,
  libxau,
  libxcb,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxcvt,
  libxdmcp,
  libxext,
  libxfixes,
  libxfont_1,
  libxfont_2,
  libxkbfile,
  libxshmfence,
  mesa,
  mesa-gl-headers,
  openssl,
  pixman,
  udev,
  xkbcomp,
  xkeyboard-config,
  xorgproto,
  xtrans,
  zlib,

  # darwin specific deps
  darwin,
  util-macros,
  libapplewm,

  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-server";
  version = "21.1.21";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/xorg-server-${finalAttrs.version}.tar.xz";
    hash = "sha256-wMvlVFs/ZFuuYCS4MNHRFUqVY1BoOk5Ssv/1sPoatRk=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./darwin/bundle_main.patch
    ./darwin/find-cpp.patch
    ./darwin/stub.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.bootstrap_cmds
    util-macros
  ];

  buildInputs = [
    font-util
    libx11
    libxau
    libxcb
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-util
    libxcb-wm
    libxcvt
    libxdmcp
    libxfixes
    libxkbfile
    mesa-gl-headers
    openssl
    xorgproto
    xtrans
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    dri-pkgconfig-stub
    libdrm
    libgbm
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libtirpc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.bootstrap_cmds
    mesa
  ];

  propagatedBuildInputs = [
    dbus
    libepoxy
    libGL
    libGLU
    libunwind
    libxext
    libxfont_1
    libxfont_2
    libxshmfence
    pixman
    xorgproto
    zlib
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ libpciaccess ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libapplewm ];

  mesonFlags = [
    "-Dxephyr=true"
    "-Dxvfb=true"
    "-Dxnest=true"
    "-Dxorg=true"

    "-Dlog_dir=/var/log"
    "-Ddefault_font_path="

    "-Dxkb_bin_dir=${xkbcomp}/bin"
    "-Dxkb_dir=${xkeyboard-config}/share/X11/xkb"
    "-Dxkb_output_dir=$out/share/X11/xkb/compiled"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "-Dxcsecurity=true"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-Dglamor=false"
    "-Dsecure-rpc=false"
    "-Dint10=false"
    "-Dpciaccess=false"
    "-Dapple-application-name=XQuartz"
    "-Dapple-applications-dir=${placeholder "out"}/Applications"
    "-Dbundle-id-prefix=org.nixos.xquartz"
    "-Dsha1=CommonCrypto"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    # fixed upstream (unreleased)
    "-Dudev=false"
    "-Dudev_kms=false"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace hw/xquartz/mach-startup/stub.c \
      --subst-var-by XQUARTZ_APP "$out/Applications/XQuartz.app"
  '';

  # default X install symlinks this to Xorg, we want XQuartz
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -sf $out/bin/Xquartz $out/bin/X
  '';

  passthru = {
    inherit (finalAttrs) version; # needed by virtualbox guest additions
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/xserver/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X server implementation by X.org";
    longDescription = ''
      The X server accepts requests from client applications to create windows, which are (normally
      rectangular) "virtual screens" that the client program can draw into.
      Windows are then composed on the actual screen by the X server (or by a separate composite
      manager) as directed by the window manager, which usually communicates with the user via
      graphical controls such as buttons and draggable titlebars and borders.

      For a comprehensive overview of X Server and X Window System, consult the following article:
      https://en.wikipedia.org/wiki/X_server
    '';
    homepage = "https://x.org/wiki";
    license = with lib.licenses; [
      # because the license list is huge (1848 lines) this is documented by line range
      # https://gitlab.freedesktop.org/xorg/xserver/-/blob/f05f269f1d5bddafe71cdfb290b118820bf17fdd/COPYING

      # 10-45, 148-170, 364-390, 431-454, 485-511, 512-534, 535-558, 1573-1593, 1692-1711, 1760-1779
      mit

      # 53-77, 124-147, 317-343, 455-484, 559-583, 629-654, 891-918, 1008-1034, 1056-1079,
      # 1296-1326, 1438-1470, 1499-1522, 1523-1548
      x11

      # 78-99, 171-191, 391-430 (doubled text), 584-605, 606-628, 707-729, 730-750, 807-828,
      # 829-853, 854-879, 880-890, 919-939, 940-962, 963-985, 986-1007, 1035-1055, 1080-1102,
      # 1103-1125, 1126-1148, 1149-1169, 1170-1192, 1193-1215, 1216-1236, 1237-1259, 1275-1295,
      # 1327-1359, 1360-1383, 1549-1572, 1594-1617, 1618-1638, 1639-1670, 1671-1691, 1712-1732,
      # 1733-1756, 1795-1814
      hpndSellVariant

      mitOpenGroup # 100-123
      hpnd # 192-214, 215-237, 344-363, 686-706, 1416-1437
      dec3Clause # 238-267
      x11NoPermitPersons # 268-292
      # missing last paragraph likely due to an error
      # https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/2097
      sgi-b-20 # 293-316
      bsd3 # 655-685, 1471-1498, 1815-1848 (BSD-4-Clause UC with rescinded third clause)
      adobeDisplayPostScript # 751-782
      ntp # 783-795
      hpndUc # 796-806
      isc # 1260-1274
      icu # 1383-1415
      # missing author/copyright notice
      # https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/2098
      hpndSellVariantMitDisclaimerXserver # 1780-1793
    ];
    mainProgram = "X";
    maintainers = [ ];
    pkgConfigModules = [ "xorg-server" ];
    platforms = lib.platforms.unix;
  };
})
