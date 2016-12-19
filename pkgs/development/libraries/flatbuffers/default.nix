{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "flatbuffers-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    sha256 = "0jsqk49h521d5h4c9gk39a8968g6rcd6520a8knbfc7ssc4028y0";
  };

  buildInputs = [ cmake ];
  enableParallelBuilding = true;

  # Not sure how tests are supposed to be run.
  # "make: *** No rule to make target 'check'.  Stop."
  doCheck = false;

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
    homepage = http://google.github.io/flatbuffers;
  };
}
