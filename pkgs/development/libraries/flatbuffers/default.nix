{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "flatbuffers";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    sha256 = "1b32kc5jp83l43w2gs1dkw2vqm2j0wi7xfxqa86m18n3l41ca734";
  };

  preConfigure = stdenv.lib.optional stdenv.buildPlatform.isDarwin ''
    rm BUILD
  '';

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  doCheck = true;
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
    homepage = https://google.github.io/flatbuffers/;
  };
}
