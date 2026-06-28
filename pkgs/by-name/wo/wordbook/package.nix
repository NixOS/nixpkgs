{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libadwaita,
  gobject-introspection,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  blueprint-compiler,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wordbook";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mufeedali";
    repo = "Wordbook";
    tag = finalAttrs.version;
    hash = "sha256-sn0ssKz/Mf+GSH8+hXAuJ59wLSHIZGFSB/9HrZNrhuc=";
  };

  wnSrc = fetchFromGitHub {
    owner = "mufeedali";
    repo = "wn";
    rev = "9b51a749ff167a0b0ded55fc5b23448a0e21eb45";
    hash = "sha256-Qh2hixZ/tilrLxVcms7hSLBnERRMUJa96ORODn8T9yo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
    blueprint-compiler
    python3
  ];

  buildInputs = [
    libadwaita
    python3
    python3.pkgs.pygobject3
    python3.pkgs.backports-zstd
    python3.pkgs.rapidfuzz
    python3.pkgs.pydantic
  ];

  # Copy the wn submodule to subprojects/wn
  postPatch = ''
    cp -rs ${finalAttrs.wnSrc}/* subprojects/wn/
  '';

  mesonFlags = [
    "-Dinstall_wn_db=false"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "${
        python3.withPackages (
          ps: with ps; [
            pygobject3
            backports-zstd
            rapidfuzz
            pydantic
          ]
        )
      }/${python3.sitePackages}"
    )
  '';

  meta = {
    description = "Offline English-English dictionary application built for GNOME";
    homepage = "https://github.com/mufeedali/Wordbook";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "wordbook";
  };
})
