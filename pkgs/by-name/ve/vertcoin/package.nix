{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  boost,
  libevent,
  autoreconfHook,
  db4,
  pkg-config,
  protobuf,
  hexdump,
  zeromq,
  gmp,
  withGui ? true,
  qt5,
}:

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

  postPatch = ''
    # Dynamically patch missing standard library headers for modern GCC
    sed -i '1i #include <cstdint>' src/chainparamsbase.h
    sed -i '1i #include <cstdint>' src/zmq/zmqabstractnotifier.h
    sed -i '1i #include <cstdint>' src/zmq/zmqpublishnotifier.h

    # Fix Boost 1.74+ filesystem API change (copy_option -> copy_options)
    sed -i 's/fs::copy_option::overwrite_if_exists/fs::copy_options::overwrite_existing/g' src/wallet/bdb.cpp

    # Fix Boost 1.85+ recursive_directory_iterator API changes
    sed -i 's/\.no_push()/.disable_recursion_pending()/g' src/wallet/walletutil.cpp
    sed -i 's/\.level()/.depth()/g' src/wallet/walletutil.cpp

    # Lobotomize the Boost macros.
    # Convert all fatal AC_MSG_ERRORs regarding Boost into AC_MSG_WARNs.
    # We will manually pass the missing variables to configureFlags instead.
    for m4file in $(find . -name "ax_boost_*.m4"); do
      sed -i 's/AC_MSG_ERROR/AC_MSG_WARN/g' "$m4file"
    done
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
    qt5.wrapQtAppsHook
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
    qt5.qtbase
    qt5.qttools
    protobuf
  ];

  enableParallelBuilding = true;

  env.CXXFLAGS = "-Wno-error -std=c++17";

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    # Manually populate the variables the macros failed to set
    "BOOST_SYSTEM_LIB=" # <-- CHANGED: Empty string, do not link!
    "BOOST_FILESYSTEM_LIB=-lboost_filesystem"
    "BOOST_PROGRAM_OPTIONS_LIB=-lboost_program_options"
    "BOOST_THREAD_LIB=-lboost_thread"
    "BOOST_CHRONO_LIB=-lboost_chrono"
    "--disable-werror"
    "--disable-tests"
    "--disable-gui-tests"
    "--disable-bench"
  ]
  ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qt5.qtbase.dev}/bin:${qt5.qttools.dev}/bin"
  ];

  meta = {
    description = "Digital currency with mining decentralisation and ASIC resistance as a key focus";
    homepage = "https://vertcoin.org/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.linux;
  };
})
