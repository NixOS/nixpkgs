{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "unstable-2022-09-11";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "56e60223c38af0f64ddc8aafad27dd3a28668e7c";
    sha256 = "sha256-tIM6CdIPq++xFbpA22zDm3D4dT9soNDe/7GRY/FyLrw=";
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
