{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  testers,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbitmaps";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xbitmaps-${finalAttrs.version}.tar.xz";
    hash = "sha256-rWytVIh4MqF9hsLM/F5Sod+rCQ+DB7FSx4sOFSnND3o=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/data/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    homepage = "https://gitlab.freedesktop.org/xorg/data/bitmaps";
    description = "X BitMap (XBM) format bitmaps commonly used in X.Org applications";
    license = with lib.licenses; [
      icu
      smlnj
    ];
    maintainers = [ ];
    pkgConfigModules = [ "xbitmaps" ];
    platforms = lib.platforms.unix;
  };
})
