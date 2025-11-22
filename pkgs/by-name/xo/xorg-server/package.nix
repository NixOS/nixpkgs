{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  callPackage,

  # build system
  buildPackages,
  pkg-config,

  # deps
  dbus,
  dri-pkgconfig-stub,
  libdrm,
  libepoxy,
  libgbm,
  libGL,
  libGLU,
  libpciaccess,
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
  xkeyboardconfig,
  xorgproto,
  xtrans,
  zlib,

  # darwin specific deps
  darwin,
  autoconf,
  automake,
  autoreconfHook,
  fontutil,
  utilmacros,
  libapplewm,

  writeScript,
  testers,
}:
let
  # XQuartz requires two compilations: the first to get X / XQuartz,
  # and the second to get Xvfb, Xnest, etc.
  darwinOtherX = callPackage ./darwin/proto-package.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-server";
  version = "21.1.20";

  outputs = [ "out" ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) "dev";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/xorg-server-${finalAttrs.version}.tar.xz";
    hash = "sha256-dpW8YYJLOoG2utL3iwVADKAVAD3kAtGzIhFxBbcC6Tc=";
  };

  patches =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      # The build process tries to create the specified logdir when building.
      #
      # We set it to /var/log which can't be touched from inside the sandbox causing the build to hard-fail
      ./dont-create-logdir-during-build.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # XQuartz patchset
      (fetchpatch {
        url = "https://github.com/XQuartz/xorg-server/commit/e88fd6d785d5be477d5598e70d105ffb804771aa.patch";
        sha256 = "1q0a30m1qj6ai924afz490xhack7rg4q3iig2gxsjjh98snikr1k";
        name = "use-cppflags-not-cflags.patch";
      })
      (fetchpatch {
        url = "https://github.com/XQuartz/xorg-server/commit/75ee9649bcfe937ac08e03e82fd45d9e18110ef4.patch";
        sha256 = "1vlfylm011y00j8mig9zy6gk9bw2b4ilw2qlsc6la49zi3k0i9fg";
        name = "use-old-mitrapezoids-and-mitriangles-routines.patch";
      })
      (fetchpatch {
        url = "https://github.com/XQuartz/xorg-server/commit/c58f47415be79a6564a9b1b2a62c2bf866141e73.patch";
        sha256 = "19sisqzw8x2ml4lfrwfvavc2jfyq2bj5xcf83z89jdxg8g1gdd1i";
        name = "revert-fb-changes-1.patch";
      })
      (fetchpatch {
        url = "https://github.com/XQuartz/xorg-server/commit/56e6f1f099d2821e5002b9b05b715e7b251c0c97.patch";
        sha256 = "0zm9g0g1jvy79sgkvy0rjm6ywrdba2xjd1nsnjbxjccckbr6i396";
        name = "revert-fb-changes-2.patch";
      })
      ./darwin/bundle_main.patch
      ./darwin/stub.patch
    ];

  strictDeps = true;

  depsBuildBuild = lib.optionals (!stdenv.hostPlatform.isDarwin) [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoreconfHook
    darwin.bootstrap_cmds
    utilmacros
    fontutil
  ];

  buildInputs = [
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
    openssl
    xorgproto
    xtrans
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    dri-pkgconfig-stub
    libdrm
    libgbm
    mesa-gl-headers
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoconf
    automake
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

  configureFlags = [
    "--with-default-font-path="
    # there were only paths containing "${prefix}",
    # and there are no fonts in this package anyway
    "--with-xkb-bin-directory=${xkbcomp}/bin"
    "--with-xkb-path=${xkeyboardconfig}/share/X11/xkb"
    "--with-xkb-output=$out/share/X11/xkb/compiled"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "--enable-kdrive" # not built by default
    "--enable-xephyr"
    "--enable-xcsecurity" # enable SECURITY extension
    "--with-log-dir=/var/log"
    "--enable-glamor"
    "--with-os-name=Nix" # r13y, embeds the build machine's kernel version otherwise
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isMusl) [
    "--disable-tls"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # note: --enable-xquartz is auto
    "CPPFLAGS=-I${./darwin/dri}"
    "--disable-libunwind" # libunwind on darwin is missing unw_strerror
    "--disable-glamor"
    "--with-apple-application-name=XQuartz"
    "--with-apple-applications-dir=\${out}/Applications"
    "--with-bundle-id-prefix=org.nixos.xquartz"
    "--with-sha1=CommonCrypto"
    "--without-dtrace" # requires Command Line Tools for Xcode
  ];

  env = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    # Needed with GCC 12
    NIX_CFLAGS_COMPILE = "-Wno-error=array-bounds";
  };

  prePatch = lib.optionalString (!stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isMusl) ''
    export CFLAGS+=" -D__uid_t=uid_t -D__gid_t=gid_t"
  '';

  postPatch = ''
    substituteInPlace dri3/*.c \
      --replace-fail '#include <drm_fourcc.h>' '#include <libdrm/drm_fourcc.h>'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace hw/xquartz/mach-startup/stub.c \
      --subst-var-by XQUARTZ_APP "$out/Applications/XQuartz.app"
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
  '';

  postInstall = ''
    rm -fr $out/share/X11/xkb/compiled # otherwise X will try to write in it
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    ( # assert() keeps runtime reference xorgserver-dev in xf86-video-intel and others
      cd "$dev"
      for f in include/xorg/*.h; do
        sed "1i#line 1 \"${finalAttrs.pname}-${finalAttrs.version}/$f\"" -i "$f"
      done
    )
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -rT ${darwinOtherX}/bin $out/bin
    rm -f $out/bin/X
    ln -s Xquartz $out/bin/X

    cp ${darwinOtherX}/share/man -rT $out/share/man
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
