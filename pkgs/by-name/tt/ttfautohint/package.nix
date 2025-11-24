{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  autoreconfHook,
  perl,
  freetype,
  harfbuzz,
  libsForQt5,
  enableGUI ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.8.4";
  pname = "ttfautohint";

  src = fetchurl {
    url = "mirror://savannah/freetype/ttfautohint-${finalAttrs.version}.tar.gz";
    hash = "sha256-iodhF/puv9L/4bNoKpqYyALA9HGJ9X09tLmXdCBoMuE=";
  };

  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      echo "${finalAttrs.version}" > VERSION
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace configure --replace-fail "macx-g++" "macx-clang"
    '';

  nativeBuildInputs = [
    pkg-config
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoreconfHook ]
  ++ lib.optionals enableGUI [ libsForQt5.qt5.wrapQtAppsHook ];

  buildInputs = [
    freetype
    harfbuzz
  ]
  ++ lib.optionals enableGUI [ libsForQt5.qt5.qtbase ];

  configureFlags = [
    ''--with-qt=${if enableGUI then "${libsForQt5.qt5.qtbase}/lib" else "no"}''
  ]
  ++ lib.optionals (!enableGUI) [ "--without-doc" ];

  enableParallelBuilding = true;

  meta = {
    description = "Automatic hinter for TrueType fonts";
    mainProgram = "ttfautohint";
    longDescription = ''
      A library and two programs which take a TrueType font as the
      input, remove its bytecode instructions (if any), and return a
      new font where all glyphs are bytecode hinted using the
      information given by FreeType’s auto-hinting module.
    '';
    homepage = "https://www.freetype.org/ttfautohint";
    license = lib.licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
