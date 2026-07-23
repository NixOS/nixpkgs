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
  pname = "xlsfonts";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xlsfonts-${finalAttrs.version}.tar.xz";
    hash = "sha256-gH+QnqzmhLhm/GOz6WJynBIIIqbJbgUf9RzzULP/ts0=";
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
    description = "Utility to list core protocol fonts on an X server";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xlsfonts";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xlsfonts";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
