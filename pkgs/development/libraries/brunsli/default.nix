{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, brotli
}:

stdenv.mkDerivation rec {
  pname = "brunsli";
  version = "0.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "brunsli";
    rev = "v${version}";
    hash = "sha256-ZcrRz2xSoRepgG8KZYY/JzgONerItW0e6mH1PYsko98=";
  };

  patches = [
    # unvendor brotli
    (fetchpatch {
      url = "https://cgit.freebsd.org/ports/plain/graphics/brunsli/files/patch-CMakeLists.txt";
      hash = "sha256-SqmkmL8r/KGvELq2em4ZLkCaKgZywZ/4fcC/enZ1nEI=";
    })
    (fetchpatch {
      url = "https://cgit.freebsd.org/ports/plain/graphics/brunsli/files/patch-brunsli.cmake";
      hash = "sha256-UmXK+NBd0+5AZX2oWnrpOnzHD7c3ghSO7oERWLOYjbA=";
    })
  ];

  postPatch = ''
    rm -r third_party
  '';

  patchFlags = [ "-p0" ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    brotli
  ];

  meta = {
    description = "Lossless JPEG repacking library";
    homepage = "https://github.com/google/brunsli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
