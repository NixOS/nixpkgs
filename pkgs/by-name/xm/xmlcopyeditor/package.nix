{
  lib,
  stdenv,
  fetchurl,
  aspell,
  boost,
  expat,
  intltool,
  pkg-config,
  libxml2,
  libxslt,
  pcre2,
  wxGTK32,
  xercesc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlcopyeditor";
  version = "1.3.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/xml-copy-editor/xmlcopyeditor-${finalAttrs.version}.tar.gz";
    hash = "sha256-6HHKl7hqyvF3gJ9vmjLjTT49prJ8KhEEV0qPsJfQfJE=";
  };

  patches = [ ./xmlcopyeditor.patch ];

  # error: cannot initialize a variable of type 'xmlErrorPtr' (aka '_xmlError *')
  #        with an rvalue of type 'const xmlError *' (aka 'const _xmlError *')
  postPatch = ''
    substituteInPlace src/wraplibxml.cpp \
      --replace-fail "xmlErrorPtr err" "const xmlError *err"
  ''
  # error: invalid type argument of unary '*' (have 'long int')
  + ''
    substituteInPlace src/wraplibxml.cpp \
      --replace-fail "initGenericErrorDefaultFunc ( NULL )" "xmlSetGenericErrorFunc( nullptr , nullptr )"
  '';

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    aspell
    boost
    expat
    libxml2
    libxslt
    pcre2
    wxGTK32
    xercesc
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  enableParallelBuilding = true;

  meta = {
    description = "Fast, free, validating XML editor";
    homepage = "https://xml-copy-editor.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      candeira
      wegank
    ];
    mainProgram = "xmlcopyeditor";
  };
})
