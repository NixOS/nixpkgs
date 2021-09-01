{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, libhandy
, elementary-icon-theme
, appstream
, libpeas
, editorconfig-core-c
, gtksourceview4
, gtkspell3
, libsoup
, vte
, webkitgtk
, zeitgeist
, ctags
, libgit2-glib
, wrapGAppsHook
, polkit
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "6.0.0";

  repoName = "code";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1w1m52mq3zr9alkxk1c0s4ncscka1km5ppd0r6zm86qan9cjwq0f";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config

    # polkit is needed for ITS rules
    polkit

    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    ctags
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
    webkitgtk
    zeitgeist
  ];

  # install script fails with UnicodeDecodeError because of printing a fancy elipsis character
  LC_ALL = "C.UTF-8";

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

  meta = with lib; {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
