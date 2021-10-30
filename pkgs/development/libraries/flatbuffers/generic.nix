{ lib
, stdenv
, fetchFromGitHub
, cmake
, version
, sha256
, patches ? [ ]
, preConfigure ? null
}:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  inherit version;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    inherit sha256;
  };

  inherit patches preConfigure;

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
    maintainers = [ maintainers.teh ];
    license = licenses.asl20;
    platforms = platforms.unix;
    homepage = "https://google.github.io/flatbuffers/";
  };
}
