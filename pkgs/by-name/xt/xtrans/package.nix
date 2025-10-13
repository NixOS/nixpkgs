{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtrans";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/xtrans-${finalAttrs.version}.tar.xz";
    hash = "sha256-+q/qFmvyRRoXPZ1ZM1KUDsZAQUXF0dpcITQjzk01npI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X Window System Protocols Transport layer shared code";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxtrans";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
      mit
      x11
      hpndSellVariant
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xtrans" ];
    platforms = lib.platforms.unix;
  };
})
