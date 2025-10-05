{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  pkg-config,
  meson,
  ninja,
  python3,
  perl,
  libxslt,
  gettext,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xkeyboard-config";
  version = "2.45";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-${finalAttrs.version}.tar.xz";
    hash = "sha256-Fp4HWpLZV6V3h8GZ6E41nfKTG3GWwcW0o9V27mI1qHw=";
  };

  patches = [
    # Patch that reverts a commit in 2.45 that broke the us-mac keyboard layout.
    # Remove when 2.46 is released.
    # https://github.com/NixOS/nixpkgs/issues/426375
    (fetchpatch2 {
      url = "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/commit/11dbaeb23d06c0d21efe538c90b44ffc8fc3a071.patch";
      hash = "sha256-qZkO1GQvbtTFeXqCuA7bjgQX5jq9c+LiKa/ziP1w2sI=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
    perl
    libxslt # xsltproc
    gettext # msgfmt
  ];

  mesonFlags = [
    (lib.mesonBool "xorg-rules-symlinks" true)
  ];

  prePatch = ''
    patchShebangs rules/merge.py rules/compat/map-variants.py rules/generate-options-symbols.py rules/xml2lst.pl
  '';

  # 1: compatibility for X11/xkb location
  # 2: I think pkg-config/ is supposed to be in /lib/
  postInstall = ''
    ln -s share "$out/etc"
    mkdir -p "$out/lib" && ln -s ../share/pkgconfig "$out/lib/"
  '';

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts

      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/data/xkeyboard-config/ \
        | sort -V | tail -n1)"

      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Provides a consistent, well-structured, database of keyboard configuration data";
    homepage = "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config";
    license = with lib.licenses; [
      hpndSellVariant
      x11
      mitOpenGroup
      mit
      hpnd
      cronyx
      # there is another unknown license at the end but it seems free
      # also see this issue https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/issues/527
      free
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
