{
  stdenv,
  lib,
  fetchFromGitHub,

  # build time
  cmake,
  pkg-config,
  libyang,

  enableExamples ? false,

  # update script
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysrepo";
  version = "3.7.11";

  src = fetchFromGitHub {
    owner = "sysrepo";
    repo = "sysrepo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v3FXY33PuM4/TXH49M6JBKweIry17TxS2ksIBm9X9wg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    libyang
  ];

  cmakeFlags = [
    "-DREPO_PATH=$out/etc"

    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optional (!enableExamples) "-DENABLE_EXAMPLES=OFF";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "YANG-based configuration and operational state data store";
    longDescription = ''
      Sysrepo is a YANG-based configuration and operational state data store for Unix/Linux applications.
    '';
    homepage = "https://github.com/sysrepo/sysrepo";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ivalery111 ];
  };
})
