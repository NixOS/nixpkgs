{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2019_U6";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = version;
    hash = "sha256-LHpJ5cbd441p3MUq5xQTpDHOvEmWjsuLNninYqgBbv0=";
  };

  nativeBuildInputs = (lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ]);

  makeFlags = lib.optionals stdenv.cc.isClang [
    "compiler=clang"
  ] ++ (lib.optional (stdenv.buildPlatform != stdenv.hostPlatform)
    (if stdenv.hostPlatform.isAarch64 then "arch=arm64"
    else if stdenv.hostPlatform.isx86_64 then "arch=intel64"
    else throw "Unsupported cross architecture"));


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
      url = "https://github.com/oneapi-src/oneTBB/raw/478de5b1887c928e52f029d706af6ea640a877be/integration/pkg-config/tbb.pc.in";
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
    maintainers = with maintainers; [ thoughtpolice tmarkus ];
  };
}
