{
  lib,
  stdenv,
  fetchurl,
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
  version = "2.46";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xkeyboard-config/xkeyboard-config-${finalAttrs.version}.tar.xz";
    hash = "sha256-EMWCGPtg0I+x97MDBN6zukdhMZWqigioHxlyd1zMNkA=";
  };

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
      hyphenBulgarian
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
