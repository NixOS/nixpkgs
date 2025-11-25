{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libpng,
  libx11,
  libxcursor,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcursorgen";
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcursorgen-${finalAttrs.version}.tar.xz";
    hash = "sha256-DMnhVqyEyhbqkCcQrzXg+v+lHRN5cHHjtLbMfL1JO7w=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpng
    libx11
    libxcursor
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
    description = "prepares X11 cursor sets for use with libXcursor";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcursorgen";
    license = lib.licenses.hpndSellVariant;
    mainProgram = "xcursorgen";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
