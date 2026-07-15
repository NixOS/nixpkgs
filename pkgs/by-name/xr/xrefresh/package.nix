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
  pname = "xrefresh";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xrefresh-${finalAttrs.version}.tar.xz";
    hash = "sha256-Ke1ZLV7ONaMCkATYxG8wAvkpcIcKlsEeOLr38RIri18=";
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
    description = "Utility to refresh all or part of an X screen";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrefresh";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
    ];
    mainProgram = "xrefresh";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
