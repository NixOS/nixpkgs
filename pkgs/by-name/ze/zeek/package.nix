{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  cmake,
  civetweb,
  flex,
  bison,
  openssl,
  libkqueue,
  libpcap,
  zlib,
  file,
  curl,
  libmaxminddb,
  gperftools,
  python3,
  swig,
  gettext,
  coreutils,
  ncurses,
  zeromq,
}:

let
  broker = callPackage ./broker { };
  python = python3.withPackages (p: [
    p.gitpython
    p.semantic-version
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zeek";
  version = "8.2.2";

  src = fetchurl {
    url = "https://download.zeek.org/zeek-${finalAttrs.version}.tar.gz";
    hash = "sha256-o7bWDva+w+sSgY/jLK7HB/m21jBT6u7pQuTsmvZNhiw=";
  };

  strictDeps = true;

  patches = [
    ./fix-installation.patch
  ];

  nativeBuildInputs = [
    bison
    cmake
    file
    flex
    python
    swig
  ];

  buildInputs = [
    broker
    civetweb
    curl
    gperftools
    libmaxminddb
    libpcap
    ncurses
    openssl
    zeromq
    zlib
    python
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libkqueue
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gettext
  ];

  postPatch = ''
    patchShebangs ./ci/collect-repo-info.py
    patchShebangs ./auxil/spicy/scripts

    # Broker statically includes prometheus-cpp, but uses nixpkgs' shared civetweb.
    substituteInPlace cmake/FindPrometheusCpp.cmake \
      --replace-fail \
        '#set(zeekdeps ''${zeekdeps} prometheus-cpp::core prometheus-cpp::pull)' \
        $'find_package(civetweb CONFIG REQUIRED)\nset(zeekdeps ''${zeekdeps} civetweb::civetweb-cpp)'
  '';

  cmakeFlags = [
    "-DBroker_ROOT=${broker}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
    "-DZEEK_ETC_INSTALL_DIR=/etc/zeek"
    "-DZEEK_LOG_DIR=/var/log/zeek"
    "-DZEEK_STATE_DIR=/var/lib/zeek"
    "-DZEEK_SPOOL_DIR=/var/spool/zeek"
    "-DDISABLE_JAVASCRIPT=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DLIBKQUEUE_ROOT_DIR=${libkqueue}"
  ];

  postInstall = ''
    for file in $out/share/zeek/base/frameworks/notice/actions/pp-alarms.zeek $out/share/zeek/base/frameworks/notice/main.zeek; do
      substituteInPlace $file \
         --replace "/bin/rm" "${coreutils}/bin/rm" \
         --replace "/bin/cat" "${coreutils}/bin/cat"
    done

    for file in $out/share/zeek/policy/misc/trim-trace-file.zeek $out/share/zeek/base/frameworks/logging/postprocessors/scp.zeek $out/share/zeek/base/frameworks/logging/postprocessors/sftp.zeek; do
      substituteInPlace $file --replace "/bin/rm" "${coreutils}/bin/rm"
    done
  '';

  passthru = {
    inherit broker;
  };

  meta = {
    description = "Network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    changelog = "https://github.com/zeek/zeek/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd3;
    mainProgram = "zeek";
    maintainers = with lib.maintainers; [
      pSub
      tobim
    ];
    platforms = lib.platforms.unix;
  };
})
