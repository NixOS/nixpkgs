{ lib, stdenv
, cmake
, fetchurl
, perl
, zlib
, groff
, withBzip2 ? false
, bzip2
, withLZMA ? false
, xz
, withOpenssl ? false
, openssl
, withZstd ? false
, zstd
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzip";
<<<<<<< HEAD
  version = "1.10.1";

  src = fetchurl {
    url = "https://libzip.org/download/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-lmmuXf46xbOJdTbchGaodMjPLA47H90I11snOIQpk2M=";
=======
  version = "1.9.2";

  src = fetchurl {
    url = "https://libzip.org/download/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-/Wp/dF3j1pz1YD7cnLM9KJDwGY5BUlXQmHoM8Q2CTG8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [ cmake perl groff ];
  propagatedBuildInputs = [ zlib ];
  buildInputs = lib.optionals withLZMA [ xz ]
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
<<<<<<< HEAD
    changelog = "https://github.com/nih-at/libzip/blob/v${finalAttrs.version}/NEWS.md";
=======
    changelog = "https://github.com/nih-at/libzip/blob/v${version}/NEWS.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
