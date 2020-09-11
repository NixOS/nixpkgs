{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    sha256 = "0f7xd66vc1lzjbn7jzd5kyqrgxpsfxi4zc7iymhb5xrwyxipjl1g";
  };

  preConfigure = stdenv.lib.optional stdenv.buildPlatform.isDarwin ''
    rm BUILD
  '';

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  cmakeFlags = [ "-DFLATBUFFERS_BUILD_TESTS=${if doCheck then "ON" else "OFF"}" ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkTarget = "test";

  meta = {
    description = "Memory Efficient Serialization Library.";
    longDescription = ''
      FlatBuffers is an efficient cross platform serialization library for
      games and other memory constrained apps. It allows you to directly
      access serialized data without unpacking/parsing it first, while still
      having great forwards/backwards compatibility.
    '';
    maintainers = [ stdenv.lib.maintainers.teh ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://google.github.io/flatbuffers/";
  };
}
