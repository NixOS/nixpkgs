{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  runCommand,

  # build-time
  autoconf,
  automake,
  bison,
  cmake,
  flex,
  gettext,
  hostname,
  libtool,
  perl,
  pkg-config,
  python3,
  util-linux,
  which,
  whoami,

  # run-time
  boost,
  bzip2,
  cairo,
  curl,
  expat,
  jansson,
  libxdmcp,
  ncurses,
  openssl,
  protobuf,
  xz,
  zlib,
  zstd,

  # test
  graphviz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vg";
  version = "1.75.0";

  src = fetchFromGitHub {
    owner = "vgteam";
    repo = "vg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2N9F9qSuLtmDcpFkycZVJo5R9PTvOZlVsyc3Wg9kokI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace \
      Makefile \
        --replace-fail "/bin/bash" "${stdenv.shell}" \
        --replace-fail "\$(shell arch)" "${stdenv.hostPlatform.uname.processor}" \
        --replace-fail "vg_git_version.hpp]" "vg_git_version.hpp ]"

    substituteInPlace \
      deps/libbdsg/bdsg/deps/pybind11/tests/CMakeLists.txt \
      deps/vcflib/CMakeLists.txt \
        --replace-fail \
          "find_package(pybind11 " \
          "set(PYBIND11_FINDPYTHON ON)
          find_package(pybind11 "

    patchShebangs ./
    patchShebangs deps/

    patch -p1 -d deps/libbdsg -i ${./0001-Use-order-only-prerequisite-for-making-sure-dirs-exi.patch}

    pushd deps/htslib
      PACKAGE_VERSION=$(./version.sh)
      echo '#define HTSCODECS_VERSION_TEXT "$PACKAGE_VERSION"' > ./htscodecs/htscodecs/version.h
    popd
  '';

  dontUseCmake = true; # cmake needed for deps, but not main package
  dontConfigure = true;
  enableParallelBuilding = true;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    bison
    cmake
    finalAttrs.passthru.customPython
    flex
    gettext
    hostname
    libtool
    perl
    pkg-config
    which
    whoami
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linux # rev, and possibly others
  ];

  buildInputs = [
    boost
    bzip2
    cairo
    curl
    expat
    jansson
    ncurses
    openssl
    protobuf
    xz
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxdmcp
  ];

  passthru.customPython = python3.withPackages (
    ps: with ps; [
      pybind11
    ]
  );

  env = {
    # needed, else build fails
    VG_GIT_VERSION = finalAttrs.src.tag;
    # deps/elfutils
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=stringop-overflow"
      "-Wno-error=unterminated-string-initialization"
    ];
  };

  makeFlags = [
    # don't build statically
    "START_STATIC="
    "END_STATIC="
  ];

  preBuild = ''
    # Install directories may not exist when parallel builds complete their
    # output steps, so we create them here to prevent build failures.
    mkdir -p lib include obj/{pic/algorithms,algorithms,config,io,subcommand,unittest/support}
  '';

  # no install target
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    cp bin/* $out/bin/
    cp -R lib/lib{handlegraph,vgio,hts,deflate}.so* $out/lib/

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    for bin in $out/bin/* ; do
      patchelf --allowed-rpath-prefixes /nix/store --shrink-rpath $bin
      patchelf --set-rpath "$out/lib:$(patchelf --print-rpath $bin)" $bin
    done

    # remove debugging symbols that make the binary bloated in size
    strip -d $out/bin/vg

    runHook postFixup
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = runCommand "test-vg-basic" { } ''
      HOME=$(mktemp -d) # fontconfig cache

      cp -R ${finalAttrs.src}/test .

      # build graph
      ${finalAttrs.finalPackage}/bin/vg construct \
        -r test/tiny/tiny.fa \
        -v test/tiny/tiny.vcf.gz \
        >x.vg

      # convert graph to image
      ${finalAttrs.finalPackage}/bin/vg view -d x.vg >x.dot
      ${graphviz}/bin/dot -Tpng x.dot -o $out
    '';
  };

  meta = {
    description = "Tools for working with genome variation graphs";
    homepage = "https://github.com/vgteam/vg";
    changelog = "https://github.com/vgteam/vg/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "vg";
    license = lib.licenses.mit;
    # TODO: build on darwin
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
