{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2020.3";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    sha256 = "prO2O5hd+Wz5iA0vfrqmyHFr0Ptzk64so5KpSpvuKmU=";
  };

  patches = [
    # Fixes build with Musl.
    (fetchurl {
      url = "https://github.com/openembedded/meta-openembedded/raw/39185eb1d1615e919e3ae14ae63b8ed7d3e5d83f/meta-oe/recipes-support/tbb/tbb/GLIBC-PREREQ-is-not-defined-on-musl.patch";
      sha256 = "gUfXQ9OZQ82qD6brgauBCsKdjLvyHafMc18B+KxZoYs=";
    })

    # Fixes build with Musl.
    (fetchurl {
      url = "https://github.com/openembedded/meta-openembedded/raw/39185eb1d1615e919e3ae14ae63b8ed7d3e5d83f/meta-oe/recipes-support/tbb/tbb/0001-mallinfo-is-glibc-specific-API-mark-it-so.patch";
      sha256 = "fhorfqO1hHKZ61uq+yTR7eQ8KYdyLwpM3K7WpwJpV74=";
    })
  ];

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  makeFlags = lib.optionals stdenv.cc.isClang [
    "compiler=clang"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp "build/"*release*"/"*${stdenv.hostPlatform.extensions.sharedLibrary}* $out/lib/
    mv include $out/
    rm $out/include/index.html

    runHook postInstall
  '';

  postInstall = let
    pcTemplate = fetchurl {
      url = "https://github.com/oneapi-src/oneTBB/raw/master/integration/pkg-config/tbb.pc.in";
      sha256 = "2pCad9txSpNbzac0vp/VY3x7HNySaYkbH3Rx8LK53pI=";
    };
  in ''
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
    maintainers = with maintainers; [ thoughtpolice dizfer ];
  };
}
