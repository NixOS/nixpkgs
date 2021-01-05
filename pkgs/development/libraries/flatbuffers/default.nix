{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  # Fixes https://github.com/google/flatbuffers/issues/5950
  # Compilation errors [gcc 10.1, Linux 5.6]
  version = "795408115ac4a54b6cde291f4703473d5ff0bf8a"; # post 1.12.0

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = version;
    sha256 = "1zaqqcjpmh8vp1bm4vms6csl1jazyflvsrn9wrmw04kayb707ily";
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
    description = "Memory Efficient Serialization Library";
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
