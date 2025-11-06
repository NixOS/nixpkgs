{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxcb,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xlsatoms";
  version = "1.1.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xlsatoms-${finalAttrs.version}.tar.xz";
    hash = "sha256-9L+hX1bAZtMmpdWykmRnCPJbkkdQaEC5BHzSaH3Mcbc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxcb ];

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
    description = "Utility to list interned atoms defined on X server";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xlsatoms";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xlsatoms";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
