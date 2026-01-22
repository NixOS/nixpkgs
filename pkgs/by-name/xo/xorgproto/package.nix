{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  python3,
  meson,
  ninja,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xorgproto";
  version = "2024.1";

  src = fetchurl {
    url = "mirror://xorg/individual/proto/xorgproto-${finalAttrs.version}.tar.xz";
    hash = "sha256-NyIl/UCBW4QjVH9diQxd68cuiLkQiPv7ExWMIElcy1k=";
  };

  patches = [
    # small fix for mingw
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/meson.patch?h=mingw-w64-xorgproto&id=7b817efc3144a50e6766817c4ca7242f8ce49307";
      sha256 = "sha256-Izzz9In53W7CC++k1bLr78iSrmxpFm1cH8qcSpptoUQ=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
    meson
    ninja
  ];

  # adds support for printproto needed for libXp
  mesonFlags = [ "-Dlegacy=true" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/proto/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Window System unified protocol definitions";
    homepage = "https://gitlab.freedesktop.org/xorg/proto/xorgproto";
    license = with lib.licenses; [
      # The copyright notices are split between each protocol, so to be able to validate this,
      # I listed all the components that have the license for each license:

      # applewm, composite, dmx, evie, fixes, input, video, windowswm, x11, xext, xf86dri
      mit
      # bigreqs, fonts, input, lg3d, pm, x11, xmisc, xext, xinerama
      mitOpenGroup
      # composite, damage, dri3, fixes, fonts, present, randr, record, render, xext, xwayland
      hpndSellVariant
      # dri2
      icu
      # fontcache
      bsd2
      # gl
      sgi-b-20
      # fonts, input, kb, trap, video, x11, xext
      hpnd
      # print, resource, scrnsaver, video, xext, xf86{bigfont,dga,misc,rush,vidmode}, xinerama
      # Note: 2 of the licenses actually omit a sentence from the x11 license that is not marked as
      # omittable by spdx. But the sentence is not integral to the license's meaning, I think.
      x11
      # x11
      hpndDifferentDisclaimer

      # fontsproto and x11proto both contain a license that is almost the X11 license, but with one
      # important difference: the sentence "Permission is hereby granted [...] to use, copy,
      # modify, merge, publish, distribute ..." is replaced with "All rights reserved."
      # Since XFree86 has the copyright and XFree86 was, at least in later releases, free software
      # under the X11 license, I will give this the benefit of the doubt and not mark a package
      # that idk 30% of nixpkgs depends on (estimate based on nothing other than most xorg stuff
      # depends on it) as unfree.
      # upstream issue: https://gitlab.freedesktop.org/xorg/proto/xorgproto/-/issues/53
      #unfree
    ];
    maintainers = [ ];
    pkgConfigModules = [
      "applewmproto"
      "bigreqsproto"
      "compositeproto"
      "damageproto"
      "dmxproto"
      "dpmsproto"
      "dri2proto"
      "dri3proto"
      "evieproto"
      "fixesproto"
      "fontcacheproto"
      "fontsproto"
      "glproto"
      "inputproto"
      "kbproto"
      "lg3dproto"
      "presentproto"
      "printproto"
      "randrproto"
      "recordproto"
      "renderproto"
      "resourceproto"
      "scrnsaverproto"
      "trapproto"
      "videoproto"
      "windowswmproto"
      "xcalibrateproto"
      "xcmiscproto"
      "xextproto"
      "xf86bigfontproto"
      "xf86dgaproto"
      "xf86driproto"
      "xf86miscproto"
      "xf86rushproto"
      "xf86vidmodeproto"
      "xineramaproto"
      "xproto"
      "xproxymngproto"
      "xwaylandproto"
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
