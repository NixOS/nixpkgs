{
  lib,
  stdenv,
  cmake,
  fetchpatch2,
  fetchurl,
  perl,
  zlib,
  groff,
  withBzip2 ? false,
  bzip2,
  withLZMA ? false,
  xz,
  withOpenssl ? false,
  openssl,
  withZstd ? false,
  zstd,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzip";
  version = "1.10.1";

  src = fetchurl {
    url = "https://libzip.org/download/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-lmmuXf46xbOJdTbchGaodMjPLA47H90I11snOIQpk2M=";
  };

  patches = [
    # https://github.com/nih-at/libzip/issues/404
    (fetchpatch2 {
      name = "Check-for-zstd_TARGET-before-using-it-in-a-regex.patch";
      url = "https://github.com/nih-at/libzip/commit/c719428916b4d19e838f873b1a177b126a080d61.patch";
      hash = "sha256-4ksbXEM8kNvs3wtbIaXLEQNSKaxl0es/sIg0EINaTHE=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    perl
    groff
  ];
  propagatedBuildInputs = [ zlib ];
  buildInputs =
    lib.optionals withLZMA [ xz ]
    ++ lib.optionals withBzip2 [ bzip2 ]
    ++ lib.optionals withOpenssl [ openssl ]
    ++ lib.optionals withZstd [ zstd ];

  # Don't build the regression tests because they don't build with
  # pkgsStatic and are not executed anyway.
  cmakeFlags = [ "-DBUILD_REGRESS=0" ];

  preCheck = ''
    # regress/runtest is a generated file
    patchShebangs regress
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    homepage = "https://libzip.org/";
    description = "A C library for reading, creating and modifying zip archives";
    license = licenses.bsd3;
    pkgConfigModules = [ "libzip" ];
    platforms = platforms.unix;
    changelog = "https://github.com/nih-at/libzip/blob/v${finalAttrs.version}/NEWS.md";
  };
})
