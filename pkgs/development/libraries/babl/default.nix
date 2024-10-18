{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gi-docgen
, gobject-introspection
, lcms2
, vala
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babl";
  version = "0.1.108";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor finalAttrs.version}/babl-${finalAttrs.version}.tar.xz";
    hash = "sha256-Jt7+neqresTQ4HbKtJwqDW69DfDDH9IJklpfB+3uFHU=";
  };

  patches = [
    # Allow overriding path to dev output that will be hardcoded e.g. in pkg-config file.
    ./dev-prefix.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
  ];

  buildInputs = [
    lcms2
  ];

  mesonFlags = [
    "-Dprefix-dev=${placeholder "dev"}"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Docs are opt-out in native but opt-in in cross builds.
    "-Dwith-docs=true"
    "-Denable-gir=true"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    description = "Image pixel format conversion library";
    mainProgram = "babl";
    homepage = "https://gegl.org/babl/";
    changelog = "https://gitlab.gnome.org/GNOME/babl/-/blob/BABL_${replaceStrings [ "." ] [ "_" ] finalAttrs.version}/NEWS";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
})
