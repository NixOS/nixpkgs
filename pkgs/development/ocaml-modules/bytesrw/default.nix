{
  lib,
  fetchzip,
  libblake3,
  libmd,
  xxHash,
  zlib,
  zstd,
  buildTopkgPackage,
}:

buildTopkgPackage rec {
  pname = "bytesrw";
  version = "0.1.0";

  minimalOCamlVersion = "4.14.0";

  src = fetchzip {
    url = "https://erratique.ch/software/bytesrw/releases/bytesrw-${version}.tbz";
    hash = "sha256-leH3uo5Q8ba22A/Mbl9pio0tW/IxCTGp77Cra7l4D80=";
  };

  # docs say these are optional, but buildTopkgPackage doesn’t handle missing
  # dependencies

  buildInputs = [
    libblake3
    libmd
    xxHash
    zlib
    zstd
  ];

  meta = {
    description = "composable, memory efficient, byte stream readers and writers compatible with effect-based concurrency";
    longDescription = ''
      Bytesrw extends the OCaml Bytes module with composable, memory efficient,
      byte stream readers and writers compatible with effect-based concurrency.

      Except for byte slice life-times, these abstractions intentionnaly
      separate away ressource management and the specifics of reading and
      writing bytes.
    '';
    homepage = "https://erratique.ch/software/bytesrw";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
