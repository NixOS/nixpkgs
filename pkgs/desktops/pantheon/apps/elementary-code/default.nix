{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, elementary-icon-theme
, appstream
, libpeas
, editorconfig-core-c
, gtksourceview3
, gtkspell3
, libsoup
, vte
, webkitgtk
, zeitgeist
, ctags
, libgit2-glib
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-code";
  version = "3.4.1";

  repoName = "code";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "158zrzyyy507rxcbsb5am9768zbakpwrl61ixab57zla7z51l0g0";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkgconfig
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
    gtksourceview3
    gtkspell3
    libgee
    libgit2-glib
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
      --prefix PATH : "${stdenv.lib.makeBinPath [ ctags ]}"
    )
  '';

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
