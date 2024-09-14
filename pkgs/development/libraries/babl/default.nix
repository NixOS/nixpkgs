{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
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
  version = "0.1.108-unstable-2024-08-19";

  outputs = [ "out" "dev" "devdoc" ];

  # src = fetchurl {
  #   url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor finalAttrs.version}/babl-${finalAttrs.version}.tar.xz";
  #   hash = "sha256-Jt7+neqresTQ4HbKtJwqDW69DfDDH9IJklpfB+3uFHU=";
  # };

  src = fetchFromGitHub rec {
    name = "babl-dev-${rev}"; # to make sure the hash is updated
    owner = "GNOME";
    repo = "babl";
    rev = "c5f97c86224a473cc3fea231f17adef84580f2cc";
    hash = "sha256-QOwrGcBoLyMdl40zNOJ8hDnHPWUzaXdjpeR7+XERf0g=";
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

  postPatch = ''
    # Bypass the need for downloading git archive.
    substitute git-version.h.in git-version.h \
      --subst-var-by BABL_GIT_VERSION "BABL_${builtins.head (builtins.split "-" finalAttrs.version)}-g${builtins.substring 0 10 finalAttrs.src.rev}" \
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';


  passthru = {
    updateScript = unstableGitUpdater {
      tagConverter = "sed s/BABL_//;s/_/./g";
    };
  };

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
