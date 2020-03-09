{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation (rec {
  pname = "flatbuffers";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v${version}";
    sha256 = "1gl8pnykzifh7pnnvl80f5prmj5ga60dp44inpv9az2k9zaqx3qr";
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
} // stdenv.lib.optionalAttrs stdenv.hostPlatform.isMusl {
  # Remove when updating to the next version.
  patches = [
    (fetchpatch {
      url = "https://github.com/google/flatbuffers/commit/2b52494047fb6e97af03e1801b42adc7ed3fd78a.diff";
      sha256 = "01k07ws0f4w7nnl8nli795wgjm4p94lxd3kva4yf7nf3pg4p8arx";
    })
  ];
})
