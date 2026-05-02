{
  lib,
  stdenv,
  fetchurl,
  libxml2,
  freetype,
  libGLU,
  libGL,
  glew,
  libsForQt5,
  autoPatchelfHook,
  python312,
  cmake,
  libjpeg,
  llvmPackages,
}:
let
  python3 = python312; # fails to build otherwise
in

stdenv.mkDerivation rec {
  pname = "tulip";
  version = "5.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/auber/tulip-${version}_src.tar.gz";
    hash = "sha256-7z21WkPi1v2AGishDmXZPAedMjgXPRnpUiHTzEnc5LY=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    libxml2
    freetype
    glew
    libjpeg
    libsForQt5.qtbase
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
  ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ python3 ]}" ];

  env.NIX_CFLAGS_COMPILE =
    # error: invalid conversion from 'unsigned char*' to 'char*'
    "-fpermissive "
    + (lib.optionalString stdenv.hostPlatform.isDarwin (toString [
      # fatal error: 'Python.h' file not found
      "-I${python3}/include/${python3.libPrefix}"
      # error: format string is not a string literal (potentially insecure)
      "-Wno-format-security"
    ]));

  # FIXME: "make check" needs Docbook's DTD 4.4, among other things.
  doCheck = false;

  meta = {
    description = "Visualization framework for the analysis and visualization of relational data";

    longDescription = ''
      Tulip is an information visualization framework dedicated to the
      analysis and visualization of relational data.  Tulip aims to
      provide the developer with a complete library, supporting the design
      of interactive information visualization applications for relational
      data that can be tailored to the problems he or she is addressing.
    '';

    homepage = "http://tulip.labri.fr/";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.all;
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
