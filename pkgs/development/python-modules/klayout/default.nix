{
  lib,
  stdenv,
  buildPythonPackage,
  curl,
  cython,
  expat,
  fixDarwinDylibNames,
  fetchFromGitHub,
  libpng,
  qt6,
  setuptools,
  tomli,
  which,
  zlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "klayout";
  version = "0.30.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WigRictn6CxOPId2YitlEm43vEw+dSRWdoareD9HtMc=";
  };

  build-system = [
    cython
    setuptools
    tomli
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    which
  ]
  ++
    # libpng-config is needed for the build on Darwin
    lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.getDev libpng)
      fixDarwinDylibNames
    ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    libpng
    curl
    expat
    zlib
  ];

  env = {
    KLAYOUT_QT_VERSION = "6";
    HAVE_QT6 = "1";
    HAVE_PNG = "1";
    HAVE_CURL = "1";
    HAVE_EXPAT = "1";
    HAVE_ZLIB = "1";

    # Ensure that there is enough space for the `fixDarwinDylibNames` hook to
    # update the install names of the output dylibs.
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";
  };

  pythonImportsCheck = [ "klayout" ];

  meta = {
    description = "KLayout’s Python API";
    homepage = "https://github.com/KLayout/klayout";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
