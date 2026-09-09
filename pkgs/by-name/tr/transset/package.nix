{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "transset";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/transset-${finalAttrs.version}.tar.xz";
    hash = "sha256-gamrdK8TdzOqjLajf4KSlIUm/n7wa4WfwP8nLEN8Czg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    xorgproto
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Utility for setting opacity/transparency property on a window";
    homepage = "https://gitlab.freedesktop.org/xorg/app/transset";
    license = with lib.licenses; [
      mit
      mitOpenGroup
      hpndSellVariant
    ];
    mainProgram = "transset";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
