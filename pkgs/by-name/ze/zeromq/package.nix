{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsodium,
  asciidoc,
  xmlto,
  enableDrafts ? false,
  fetchpatch,
  # for passthru.tests
  azmq,
  cppzmq,
  czmq,
  zmqpp,
  ffmpeg,
  python3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zeromq";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q2h5y0Asad+fGB9haO4Vg7a1ffO2JSb7czzlhmT3VmI=";
  };

  patches = [
    # Use proper STREQUAL instead of EQUAL to compare strings
    # See: https://github.com/zeromq/libzmq/pull/4711
    (fetchpatch {
      url = "https://github.com/zeromq/libzmq/pull/4711/commits/55bd6b3df06734730d3012c17bc26681e25b549d.patch";
      hash = "sha256-/FVah+s7f1hWXv3MXkYfIiV1XAiMVDa0tmt4BQmSgmY=";
      name = "cacheline_undefined.patch";
    })

    # Fix the build with CMake 4.
    (fetchpatch {
      name = "zeromq-fix-cmake-4-1.patch";
      url = "https://github.com/zeromq/libzmq/commit/34f7fa22022bed9e0e390ed3580a1c83ac4a2834.patch";
      hash = "sha256-oauAZV6pThplcn2v9mQxhxlUhYgpbly0JBLYik+zoJE=";
    })
    (fetchpatch {
      name = "zeromq-fix-cmake-4-2.patch";
      url = "https://github.com/zeromq/libzmq/commit/b91a6201307b72beb522300366aad763d19b1456.patch";
      hash = "sha256-FKvZi7pTUx+wLUR8Suf+pRFg8I5OHpJ93gEmTxUrmO4=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    asciidoc
    xmlto
  ];

  buildInputs = [ libsodium ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_CURVE" true)
    (lib.cmakeBool "ENABLE_DRAFTS" enableDrafts)
    (lib.cmakeBool "WITH_LIBSODIUM" true)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  postBuild = ''
    # From https://gitlab.archlinux.org/archlinux/packaging/packages/zeromq/-/blob/main/PKGBUILD
    # man pages aren't created when using cmake
    # https://github.com/zeromq/libzmq/issues/4160
    pushd ../doc
    for FILE in *.txt; do
        asciidoc \
            -d manpage \
            -b docbook \
            -f asciidoc.conf \
            -a zmq_version="${finalAttrs.version}" \
            "''${FILE}"
        xmlto --skip-validation man "''${FILE%.txt}.xml"
    done
    popd
  '';

  postInstall = ''
    # Install manually created man pages
    install -vDm644 -t "$out/share/man/man3" ../doc/*.3
    install -vDm644 -t "$out/share/man/man7" ../doc/*.7
  '';

  passthru.tests = {
    inherit
      azmq
      cppzmq
      czmq
      zmqpp
      ;
    pyzmq = python3.pkgs.pyzmq;
    ffmpeg = ffmpeg.override { withZmq = true; };
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "Intelligent Transport Layer";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
    pkgConfigModules = [ "libzmq" ];
  };
})
