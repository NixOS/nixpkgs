{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2020.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    sha256 = "prO2O5hd+Wz5iA0vfrqmyHFr0Ptzk64so5KpSpvuKmU=";
  };

  patches = [
    # Fixes build with Musl.
    (fetchpatch {
      url = "https://github.com/openembedded/meta-openembedded/raw/39185eb1d1615e919e3ae14ae63b8ed7d3e5d83f/meta-oe/recipes-support/tbb/tbb/GLIBC-PREREQ-is-not-defined-on-musl.patch";
      hash = "sha256-Oo5FSBPPBaOziWEBOlRmTmbulExMsAmQWBR5faOj1a0=";
    })

    # Fixes build with Musl.
    (fetchpatch {
      url = "https://github.com/openembedded/meta-openembedded/raw/39185eb1d1615e919e3ae14ae63b8ed7d3e5d83f/meta-oe/recipes-support/tbb/tbb/0001-mallinfo-is-glibc-specific-API-mark-it-so.patch";
      hash = "sha256-xp8J/il855VTFIKCN/bFtf+vif6HzcVl4t4/L9nW/xk=";
    })

    # Fixes build with upcoming gcc-13:
    #  https://github.com/oneapi-src/oneTBB/pull/833
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/oneapi-src/oneTBB/pull/833/commits/c18342ba667d1f33f5e9a773aa86b091a9694b97.patch";
      hash = "sha256-LWgf7Rm6Zp4TJdvMqnAkoAebbVS+WV2kB+4iY6jRka4=";
    })

    # Fixes build for aarch64-darwin
    (fetchpatch {
      name = "aarch64-darwin.patch";
      url = "https://github.com/oneapi-src/oneTBB/pull/258/commits/86f6dcdc17a8f5ef2382faaef860cfa5243984fe.patch";
      hash = "sha256-+sNU8yEsVVmQYOCKmlNiyJfKmB/U0GKAmrydwkfrDFQ=";
    })
  ];

  nativeBuildInputs = (
    lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ]
  );

  makeFlags =
    lib.optionals stdenv.cc.isClang [
      "compiler=clang"
    ]
    ++ (lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) (
      if stdenv.hostPlatform.isAarch64 then
        "arch=arm64"
      else if stdenv.hostPlatform.isx86_64 then
        "arch=intel64"
      else if stdenv.hostPlatform.isi686 then
        "arch=ia32"
      else
        throw "Unsupported cross architecture"
    ));

  # Fix undefined reference errors with version script under LLVM.
  NIX_LDFLAGS = lib.optionalString (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "--undefined-version";

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp "build/"*release*"/"*${stdenv.hostPlatform.extensions.sharedLibrary}* $out/lib/
    mv include $out/
    rm $out/include/index.html

    runHook postInstall
  '';

  postInstall =
    let
      pcTemplate = fetchurl {
        url = "https://github.com/oneapi-src/oneTBB/raw/478de5b1887c928e52f029d706af6ea640a877be/integration/pkg-config/tbb.pc.in";
        sha256 = "2pCad9txSpNbzac0vp/VY3x7HNySaYkbH3Rx8LK53pI=";
      };
    in
    ''
      # Generate pkg-config file based on upstream template.
      # It should not be necessary with tbb after 2021.2.
      mkdir -p "$out/lib/pkgconfig"
      substitute "${pcTemplate}" "$out/lib/pkgconfig/tbb.pc" \
        --subst-var-by CMAKE_INSTALL_PREFIX "$out" \
        --subst-var-by CMAKE_INSTALL_LIBDIR "lib" \
        --subst-var-by CMAKE_INSTALL_INCLUDEDIR "include" \
        --subst-var-by TBB_VERSION "${version}" \
        --subst-var-by TBB_LIB_NAME "tbb"
    '';

  meta = with lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      tmarkus
    ];
  };
}
