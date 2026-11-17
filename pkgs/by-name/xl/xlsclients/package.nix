{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxcb,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xlsclients";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xlsclients-${finalAttrs.version}.tar.xz";
    hash = "sha256-kJgQo/29AdhHR5B/LAzDLucy53r8iMsxCrudFVsqCAc=";
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
    description = "Utility to list client applications running on a X11 display";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xlsclients";
    license = with lib.licenses; [
      mitOpenGroup
      mit
    ];
    mainProgram = "xlsclients";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
