{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxrandr,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xev";
  version = "1.2.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xev-${finalAttrs.version}.tar.xz";
    hash = "sha256-YeHF4AismXOsp83d826d90EOdwg7Aw6wT03HN8UYB9c=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorgproto
    libx11
    libxrandr
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
    description = "X event monitor";
    longDescription = ''
      xev creates a window and then asks the X server to send it X11 events whenever anything
      happens to the window (such as it being moved, resized, typed in, clicked in, etc.).
      You can also attach it to an existing window. It is useful for seeing what causes events to
      occur and to display the information that they contain; it is essentially a debugging and
      development tool, and should not be needed in normal usage.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xev";
    license = lib.licenses.x11;
    mainProgram = "xev";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
