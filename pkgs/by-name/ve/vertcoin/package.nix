{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  boost177,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  gmp,
  withGui ? true,
  libsForQt5,
}:

let
  boost = boost177;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "vertcoin";
  version = "0.18.0";

  name = finalAttrs.pname + toString (lib.optional (!withGui) "d") + "-" + finalAttrs.version;

  src = fetchFromGitHub {
    owner = "vertcoin-project";
    repo = "vertcoin-core";
    rev = "2bd6dba7a822400581d5a6014afd671fb7e61f36";
    sha256 = "ua9xXA+UQHGVpCZL0srX58DDUgpfNa+AAIKsxZbhvMk=";
  };

  # Dynamically patch missing standard library headers for modern GCC
  postPatch = ''
    sed -i '1i #include <cstdint>' src/chainparamsbase.h
    sed -i '1i #include <cstdint>' src/zmq/zmqabstractnotifier.h
    sed -i '1i #include <cstdint>' src/zmq/zmqpublishnotifier.h
  '';

  patches = [
    # Fix build on gcc-13 due to missing <stdexcept> headers
    (fetchpatch {
      name = "gcc-13-p1.patch";
      url = "https://github.com/vertcoin-project/vertcoin-core/commit/398768769f85cc1b6ff212ed931646b59fa1acd6.patch";
      hash = "sha256-4nnE4W0Z5HzVaJ6tB8QmyohXmt6UHUGgDH+s9bQaxhg=";
    })
    (fetchpatch {
      name = "gcc-13-p2.patch";
      url = "https://github.com/vertcoin-project/vertcoin-core/commit/af862661654966d5de614755ab9bd1b5913e0959.patch";
      hash = "sha256-4hcJIje3VAdEEpn2tetgvgZ8nVft+A64bfWLspQtbVw=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ]
  ++ lib.optionals withGui [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
    gmp
  ]
  ++ lib.optionals withGui [
    libsForQt5.qtbase
    libsForQt5.qttools
    protobuf
  ];

  enableParallelBuilding = true;

  # Inject the Boost backward-compatibility flag directly into the C++ compiler
  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error -std=c++17";
  };

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-werror"
    "--disable-tests"
    "--disable-gui-tests"
    "--disable-bench"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${libsForQt5.qtbase.dev}/bin:${libsForQt5.qttools.dev}/bin"
  ];

  meta = {
    description = "Digital currency with mining decentralisation and ASIC resistance as a key focus";
    homepage = "https://vertcoin.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
})
