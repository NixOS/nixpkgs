{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    sha256 = "sha256-0bJ0n/5yzj6lHXLKJzHUS0Bnlmys+X7pY/3LGapVh6k=";
  };

  nativeBuildInputs = [ cmake python3 ];

  postPatch = ''
    # Fix default value of "test_data_path" to make tests work
    substituteInPlace tests/test.cpp --replace '"tests/";' '"../tests/";'
  '';

  cmakeFlags = [
    "-DFLATBUFFERS_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DFLATBUFFERS_OSX_BUILD_UNIVERSAL=OFF"
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
