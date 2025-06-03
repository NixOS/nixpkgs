{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  automake,
  autoconf,
  libtool,
  testers,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "util-macros";
  version = "1.20.2";

  src = fetchurl {
    url = "mirror://xorg/individual/util/util-macros-${finalAttrs.version}.tar.xz";
    hash = "sha256-msJp66JPZy19ezV05L5fMz0T8Ep3EjA7GCGypRrILo4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  # not needed for releases, we propagate the needed tools
  propagatedNativeBuildInputs = [
    automake
    autoconf
    libtool
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/util/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "GNU autoconf macros shared across X.Org projects";
    homepage = "https://gitlab.freedesktop.org/xorg/util/macros";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xorg-macros" ];
    platforms = lib.platforms.unix;
  };
})
