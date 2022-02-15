{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, appstream
, desktop-file-utils
, meson
, ninja
, pkg-config
, polkit
, python3
, vala
, wrapGAppsHook
, editorconfig-core-c
, elementary-icon-theme
, granite
, gtk3
, gtksourceview4
, gtkspell3
, libgee
, libgit2-glib
, libhandy
, libpeas
, libsoup
, vte
, ctags
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = version;
    sha256 = "sha256-AXmMcPj2hf33G5v3TUg+eZwaKOdVlRvoVXglMJFHRjw=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://github.com/elementary/code/pull/1165
    (fetchpatch {
      url = "https://github.com/elementary/code/commit/a2607cce3a6b1bb62d02456456d3cbc3c6530bb0.patch";
      sha256 = "sha256-VKR83IOUYsQhBRlU9JUTlMJtXWv/AyG4wDsjMU2vmU8=";
    })
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    polkit # needed for ITS rules
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    editorconfig-core-c
    elementary-icon-theme
    granite
    gtk3
    gtksourceview4
    gtkspell3
    libgee
    libgit2-glib
    libhandy
    libpeas
    libsoup
    vte
  ];

  # ctags needed in path by outline plugin
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ctags ]}"
    )
  '';

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.code";
  };
}
