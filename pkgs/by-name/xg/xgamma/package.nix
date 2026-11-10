{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxxf86vm,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xgamma";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xgamma-${finalAttrs.version}.tar.xz";
    hash = "sha256-mPn2nlOhHDVKZjfqXD12mc61xbH4rW8KFNmTHloQ0Hk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxxf86vm
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
    description = "Utility to query and alter the gamma correction of a X monitor";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xgamma";
    license = with lib.licenses; [
      x11
      hpndSellVariant
    ];
    mainProgram = "xgamma";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
