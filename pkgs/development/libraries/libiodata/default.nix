{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  bison,
  flex,
  qmake,
  pkg-config,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiodata";
  version = "0.19.14";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "libiodata";
    tag = finalAttrs.version;
    hash = "sha256-hhcPKZtg9PEE6rrEfRJ/e4E5xMyButH0Rm0eM3iHPh8=";
  };

  patches = [
    # Remove when version > 0.19.14
    (fetchpatch {
      name = "0001-libiodata-Fix-dependencies-between-sub-projects.patch";
      url = "https://github.com/sailfishos/libiodata/commit/85517a9f2103e461cbb69dc195335df73b7a8b7e.patch";
      hash = "sha256-qrRZ1Af5uBJvEoRHifgUSeVHFC5RATDsL3374CmoUDc=";
    })
  ];

  postPatch = ''
    substituteInPlace root.pro \
      --replace-fail '$$[QT_HOST_DATA]' "$dev"

    substituteInPlace src/src.pro \
      --replace-fail '$$[QT_INSTALL_LIBS]' "$out/lib" \
      --replace-fail '/usr/include' "$dev/include"

    substituteInPlace tests/tests.pro \
      --replace-fail '/usr/bin' "$dev/bin" \
      --replace-fail '/usr/share' "$dev/share"

    substituteInPlace type-to-cxx/type-to-cxx.pro \
      --replace-fail '/usr/bin' "$dev/bin"
  '';

  # QMake doesn't handle strictDeps well
  strictDeps = false;

  nativeBuildInputs = [
    bison
    flex
    pkg-config
    qmake
  ];

  buildInputs = [
    libxcrypt
  ];

  dontWrapQtApps = true;

  postConfigure = ''
    make qmake_all
  '';

  env.IODATA_VERSION = "${finalAttrs.version}";

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Library for reading and writing simple structured data";
    homepage = "https://github.com/sailfishos/libiodata";
    changelog = "https://github.com/sailfishos/libiodata/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
