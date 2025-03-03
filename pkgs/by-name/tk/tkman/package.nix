{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  tk,
  groff,
  rman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tkman";
  version = "2.2";

  src = fetchzip {
    url = "mirror://sourceforge/tkman/tkman-${finalAttrs.version}.tar.gz";
    hash = "sha256-S4ffz+7zmVy9+isz/8q+FV4wF5Rw2iL1ftY8RsJjRLs=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-text/tkman/files/tkman-CVE-2008-5137.diff?id=dec60bb6900d6ebdaaa6aa1dcb845b30b739f9b5";
      hash = "sha256-l97SY2/YnMgzHYKnVYCVJKV7oGLN1hXNpeHFlLVzTMA=";
    })
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "WISH=${tk}/bin/wish"
    "rman=${rman}/bin/rman"
    # TODO package glimpse https://github.com/gvelez17/glimpse
    "glimpse=\"\""
  ];

  preBuild = ''
    makeFlagsArray+=(
      'manformat="${groff}/bin/groff -te -Tlatin1 -mandoc $$manx(longtmp) -"'
    )
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/tkman \
      --run 'export MANPATH="$(manpath)"'
    rm $out/bin/retkman # doesn't work
    install -Dm644 contrib/TkMan.gif $out/share/icons/hicolor/64x64/apps/tkman.gif
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "tkman";
      desktopName = "TkMan";
      comment = "Graphical man page and info viewer";
      exec = "tkman %f";
      icon = "tkman";
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    description = "Graphical, hypertext manual page and Texinfo browser for UNIX";
    mainProgram = "tkman";
    longDescription = ''
      TkMan is a graphical, hypertext manual page and Texinfo browser for UNIX.
      TkMan boasts hypertext links, unmatched online text formatting and display
      quality, (optional) outline view of man pages, high quality display and
      superior navigational interface to Texinfo documents, a novel information
      visualization mechanism called Notemarks, full text search among man pages
      and Texinfo, incremental and regular expression search within pages,
      regular expression search within Texinfo that shows all matches (not just
      the next), robustly attached yellow highlight annotations, a shortcut/hot
      list, lists of all pages in user configurable volumes, a comprehensive
      Preferences panel, and man page versioning support, among many other features.
    '';
    homepage = "https://tkman.sourceforge.net/index.html";
    license = licenses.artistic1;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fgaz ];
  };
})
