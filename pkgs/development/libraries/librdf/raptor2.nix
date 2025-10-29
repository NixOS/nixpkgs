{
  lib,
  stdenv,
  libxml2,
  curl,
  libxslt,
  pkg-config,
  cmake,
  fetchFromGitHub,
  perl,
  bison,
  flex,
  fetchpatch,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "raptor2";
  version = "2.0.16";
  underscoredVersion = lib.strings.replaceStrings [ "." ] [ "_" ] version;

  src = fetchFromGitHub {
    owner = "dajobe";
    repo = "raptor";
    rev = "${pname}_${underscoredVersion}";
    sha256 = "sha256-Eic63pV2p154YkSmkqWr86fGTr+XmVGy5l5/6q14LQM=";
  };

  cmakeFlags = [
    # Build defaults to static libraries.
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ];

  patches = [
    # pull upstream fix for libxml2-2.11 API compatibility, part of unreleased 2.0.17
    #   https://github.com/dajobe/raptor/pull/58
    (fetchpatch {
      name = "libxml2-2.11.patch";
      url = "https://github.com/dajobe/raptor/commit/4dbc4c1da2a033c497d84a1291c46f416a9cac51.patch";
      hash = "sha256-fHfvncGymzMtxjwtakCNSr/Lem12UPIHAAcAac648w4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    bison
    flex
  ];
  buildInputs = [
    curl
    libxml2
    libxslt
  ];

  # Fix the build with CMake 4.
  #
  # See: <https://github.com/dajobe/raptor/issues/75>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10)'
  '';

  meta = {
    description = "RDF Parser Toolkit";
    mainProgram = "rapper";
    homepage = "https://librdf.org/raptor";
    license = with lib.licenses; [
      lgpl21
      asl20
    ];
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.unix;
  };
}
