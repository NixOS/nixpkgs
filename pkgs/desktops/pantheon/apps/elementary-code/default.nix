{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja, vala, substituteAll
, python3, desktop-file-utils, gtk3, granite, libgee, elementary-icon-theme
, appstream, libpeas, editorconfig-core-c, gtksourceview3, gtkspell3, libsoup
, vte, webkitgtk, zeitgeist, ctags, libgit2-glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "code";
  version = "3.1.0";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "04clzms1gw7dr611kr8bhca2dww0x65186al4sjqmln4g12ry1gx";
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
    homepage = https://github.com/elementary/code;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
