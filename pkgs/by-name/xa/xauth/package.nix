{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxau,
  libxext,
  libxmu,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xauth";
  version = "1.1.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xauth-${finalAttrs.version}.tar.xz";
    hash = "sha256-6TGBQUZK17TcD4VkpYDw0g+XfIWjiMxA1admIGFRxpA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxau
    libxext
    libxmu
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
    description = "X authority file utility";
    longDescription = ''
      The xauth program is used to edit and display the authorization information used in connecting
      to the X server.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xauth";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xauth";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
