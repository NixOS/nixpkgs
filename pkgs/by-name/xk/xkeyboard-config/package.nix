{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  python3,
  perl,
  libxslt,
  gettext,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xkeyboard-config";
  version = "2.49";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xkeyboard-config";
    repo = "xkeyboard-config";
    tag = "xkeyboard-config-${finalAttrs.version}";
    hash = "sha256-55CigEgcPNc3YQlwFVKv+fV5W9JYwnsi9ZPgs13Z14w=";
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
    updateScript = gitUpdater { };
  };

  __structuredAttrs = true;

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
