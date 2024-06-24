{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, freetype
, wafHook
, python3
, libXmu
, glew-egl
, ucs-fonts
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zutty";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "tomscii";
    repo = "zutty";
    rev = finalAttrs.version;
    hash = "sha256-b/q7hIi/U/GkKo+MIFX2wWnHZAy5rQGXNul3I1pxo1Q=";
  };

  postPatch = ''
    substituteInPlace src/options.h \
      --replace /usr/share/fonts ${ucs-fonts}/share/fonts
  '';

  nativeBuildInputs = [
    pkg-config
    wafHook
    python3
  ];

  buildInputs = [
    freetype
    libXmu
    glew-egl
  ];

  meta = {
    homepage = "https://tomscii.sig7.se/zutty/";
    description = "X terminal emulator rendering through OpenGL ES Compute Shaders";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.quag ];
    platforms = lib.platforms.linux;
  };
})
