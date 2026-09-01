{
  lib,
  stdenv,
  fetchurl,
  gnutls,
  guile_1_8,
  xmodmap,
  which,
  freetype,
  libjpeg,
  sqlite,
  texliveSmall ? null,
  aspell ? null,
  git ? null,
  python3 ? null,
  cmake,
  pkg-config,
  xdg-utils,
  qt6,
  ghostscriptX ? null,
  extraFonts ? true,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false,
}:

let
  extraFontsSrc = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/fonts/TeXmacs-extra-fonts-1.0-noarch.tar.gz";
    hash = "sha256-ZxobwAjIuZpxF7v3QsLa4UTA5+Sq0rWg8smX1Kp81EM=";
  };

  fullFontsSrc = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/fonts/TeXmacs-windows-fonts-1.0-noarch.tar.gz";
    hash = "sha256-Tui4RR7Hd7MxQTvYFcEKBGro6L+uyuIp6HueevGVv/s=";
  };

  chineseFontsSrc = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/fonts/TeXmacs-chinese-fonts.tar.gz";
    hash = "sha256-1wnVlFpFjJAjGlVaEm7/TTGO+6isFlFyV9rV0rXE+Xo=";
  };

  japaneseFontsSrc = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/fonts/TeXmacs-japanese-fonts.tar.gz";
    hash = "sha256-VgbBe+wwVrgCLzcj8qepeSx11bqcxR5MS2W+o/T+xrY=";
  };

  koreanFontsSrc = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/fonts/TeXmacs-korean-fonts.tar.gz";
    hash = "sha256-EBZ3BCOcTufzvfJzptLupkCRBwSdK0qqXXJUXE95XR0=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "texmacs";
  version = "2.1.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-s6EnvbqOeQELI5KRQVy+NDEzNSHiRHeoFLWG4bQCc2A=";
  };

  postPatch =
    (
      if texliveSmall == null then
        ''
          gunzip < ${fullFontsSrc} | (cd TeXmacs && tar xvf -)
        ''
      else
        lib.optionalString extraFonts ''
          gunzip < ${extraFontsSrc} | (cd TeXmacs && tar xvf -)
        ''
    )
    + (lib.optionalString chineseFonts ''
      gunzip < ${chineseFontsSrc} | (cd TeXmacs && tar xvf -)
    '')
    + (lib.optionalString japaneseFonts ''
      gunzip < ${japaneseFontsSrc} | (cd TeXmacs && tar xvf -)
    '')
    + (lib.optionalString koreanFonts ''
      gunzip < ${koreanFontsSrc} | (cd TeXmacs && tar xvf -)
    '')
    + ''
      substituteInPlace configure \
        --replace-fail "-mfpmath=sse -msse2" ""
    '';

  nativeBuildInputs = [
    guile_1_8
    pkg-config
    qt6.wrapQtAppsHook
    xdg-utils
    cmake
  ];

  buildInputs = [
    gnutls
    guile_1_8
    qt6.qtbase
    qt6.qtsvg
    qt6.qt5compat
    freetype
    libjpeg
    sqlite
  ];

  cmakeFlags = [
    (lib.cmakeFeature "TEXMACS_GUI" "Qt6")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "./TeXmacs.app/Contents/Resources")
  ];

  env.NIX_LDFLAGS = "-lz";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv TeXmacs.app $out/Applications/
    makeWrapper $out/Applications/TeXmacs.app/Contents/MacOS/TeXmacs $out/bin/texmacs
  '';

  qtWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      xmodmap
      which
      ghostscriptX
      aspell
      texliveSmall
      git
      python3
    ])
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--set"
    "TEXMACS_PATH"
    "${placeholder "out"}/Applications/TeXmacs.app/Contents/Resources/share/TeXmacs"
  ];

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapQtApp $out/bin/texmacs
  '';

  meta = {
    description = "WYSIWYW editing platform with special features for scientists";
    longDescription = ''
      GNU TeXmacs is a free wysiwyw (what you see is what you want)
      editing platform with special features for scientists.  The software
      aims to provide a unified and user friendly framework for editing
      structured documents with different types of content (text,
      graphics, mathematics, interactive content, etc.).  The rendering
      engine uses high-quality typesetting algorithms so as to produce
      professionally looking documents, which can either be printed out or
      presented from a laptop.

      The software includes a text editor with support for mathematical
      formulas, a small technical picture editor and a tool for making
      presentations from a laptop.  Moreover, TeXmacs can be used as an
      interface for many external systems for computer algebra, numerical
      analysis, statistics, etc.  New presentation styles can be written
      by the user and new features can be added to the editor using the
      Scheme extension language.  A native spreadsheet and tools for
      collaborative authoring are planned for later.
    '';
    homepage = "http://texmacs.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.roconnor ];
    platforms = lib.platforms.all;
  };
})
