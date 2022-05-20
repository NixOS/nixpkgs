{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    sha256 = "1zbf6bdpps8369r1ql00irxrp58jnalycc8jcapb8iqg654vlfz8";
  };

  patches = [
    # Pull patch pending upstream inclustion for gcc-12 support:
    # https://github.com/google/flatbuffers/pull/6946
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://github.com/google/flatbuffers/commit/17d9f0c4cf47a9575b4f43a2ac33eb35ba7f9e3e.patch";
      sha256 = "0sksk47hi7camja9ppnjr88jfdgj0nxqxy8976qs1nx73zkgbpf9";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFLATBUFFERS_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkTarget = "test";

  meta = with lib; {
    description = "Memory Efficient Serialization Library";
    longDescription = ''
      FlatBuffers is an efficient cross platform serialization library for
      games and other memory constrained apps. It allows you to directly
      access serialized data without unpacking/parsing it first, while still
      having great forwards/backwards compatibility.
    '';
    homepage = "https://google.github.io/flatbuffers/";
    license = licenses.asl20;
    maintainers = [ maintainers.teh ];
    mainProgram = "flatc";
    platforms = platforms.unix;
  };
}
