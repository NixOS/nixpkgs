{ lib
, stdenv
, libxml2
, libxslt
, pkg-config
, cmake
, fetchFromGitHub
, perl
, bison
, flex
, fetchpatch
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "raptor2";
  version = "unstable-2022-06-06";

  src = fetchFromGitHub {
    owner = "dajobe";
    repo = "raptor";
    rev = "3cca62a33da68143b687c9e486eefc7c7cbb4586";
    sha256 = "sha256-h03IyFH1GHPqajfHBBTb19lCEu+VXzQLGC1wiEGVvgY=";
  };

  cmakeFlags = [
    # Build defaults to static libraries.
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ];

  patches = [
    # https://github.com/dajobe/raptor/pull/52
    (fetchpatch {
      name = "fix-cmake-generated-pc-file";
      url = "https://github.com/dajobe/raptor/commit/fa1ef9a27d8762f5588ac2e92554a188e73dee9f.diff";
      sha256 = "sha256-zXIbrYGgC9oTpiD0WUikT4vRdc9b6bsyfnDkwUSlqao=";
    })
    # pull upstream fix for libxml2-2.11 API compatibility:
    #   https://github.com/dajobe/raptor/pull/58
    (fetchpatch {
      name = "libxml2-2.11.patch";
      url = "https://github.com/dajobe/raptor/commit/4dbc4c1da2a033c497d84a1291c46f416a9cac51.patch";
      hash = "sha256-fHfvncGymzMtxjwtakCNSr/Lem12UPIHAAcAac648w4=";
    })
  ];

  nativeBuildInputs = [ pkg-config cmake perl bison flex ];
  buildInputs = [ libxml2 libxslt ];

  meta = {
    description = "The RDF Parser Toolkit";
    mainProgram = "rapper";
    homepage = "https://librdf.org/raptor";
    license = with lib.licenses; [ lgpl21 asl20 ];
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.unix;
  };
}
