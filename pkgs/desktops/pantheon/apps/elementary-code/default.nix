{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, vala, substituteAll
, python3, glibcLocales, desktop-file-utils, gtk3, granite, libgee, elementary-icon-theme
, appstream, libpeas, editorconfig-core-c, gtksourceview3, gtkspell3, libsoup
, vte, webkitgtk, zeitgeist, ctags, libgit2-glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "code";
  version = "3.0.2";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0zmm4a7galrs9phiplf6cygwq3rplghv7r8g47mi4nlndgxqyssg";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glibcLocales
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    ctags
    elementary-icon-theme
    editorconfig-core-c
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

  # See: https://github.com/elementary/code/pull/626
  LIBRARY_PATH = stdenv.lib.makeLibraryPath [ editorconfig-core-c ];

  # install script fails with UnicodeDecodeError because of printing a fancy elipsis character
  LC_ALL = "en_US.UTF-8";

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
    homepage = https://github.com/elementary/code;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
