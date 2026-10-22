{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libfs,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xfsinfo";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xfsinfo-${finalAttrs.version}.tar.xz";
    hash = "sha256-roBZK2Bj2pKOPQyBAjcJsvopoE/NpJ9sNjrFedl/I6I=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libfs
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
    description = "X font server information utility";
    longDescription = ''
      xfsinfo is a utility for displaying information about an X font server.
      It is used to examine the capabilities of a server, the predefined values for various
      parameters used in communicating between clients and the server, and the font catalogues and
      alternate servers that are available.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xfsinfo";
    license = with lib.licenses; [
      mitOpenGroup
      hpndSellVariant
    ];
    mainProgram = "xfsinfo";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
