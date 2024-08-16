{ lib, stdenv, fetchurl, fetchpatch, boost, cmake, libgeotiff, libtiff, laszip_2, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libLAS";
  version = "1.8.1";

  src = fetchurl {
    url = "https://download.osgeo.org/liblas/libLAS-${version}.tar.bz2";
    sha256 = "0xjfxb3ydvr2258ji3spzyf81g9caap19ql2pk91wiivqsc4mnws";
  };

  patches = [
    (fetchpatch {
      name = "aarch64-darwin.patch";
      url = "https://github.com/libLAS/libLAS/commit/ded463732db1f9baf461be6f3fe5b8bb683c41cd.patch";
      sha256 = "sha256-aWMpazeefDHE9OzuLR3FJ8+oXeGhEsk1igEm6j2DUnw=";
    })
    (fetchpatch {
      name = "fix-build-with-boost-1.73-1.patch";
      url = "https://github.com/libLAS/libLAS/commit/af431abce95076b59f4eb7c6ef0930ca57c8a063.patch";
      hash = "sha256-2lr028t5hq3oOLZFXnvIJXCUsoVHbG/Mus93OZvi5ZU=";
    })
    (fetchpatch {
      name = "fix-build-with-boost-1.73-2.patch";
      url = "https://github.com/libLAS/libLAS/commit/0d3b8d75f371a6b7c605bbe5293091cb64a7e2d3.patch";
      hash = "sha256-gtNIazR+l1h+Xef+4qQc7EVi+Nlht3F8CrwkINothtA=";
    })
    # remove on update. fix compile error in apps/las2col.c
    # https://github.com/libLAS/libLAS/pull/151
    (fetchpatch {
      name = "fflush-x2-is-not-an-fsync.patch";
      url = "https://github.com/libLAS/libLAS/commit/e789d43df4500da0c12d2f6d3ac1d031ed835493.patch";
      hash = "sha256-0zI0NvOt9C5BPrfAbgU1N1kj3rZFB7rf0KRj7yemyWI=";
    })
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ boost libgeotiff libtiff laszip_2 ];

  cmakeFlags = [
    "-DWITH_LASZIP=ON"
    # libLAS is currently not compatible with LASzip 3,
    # see https://github.com/libLAS/libLAS/issues/144.
    "-DLASZIP_INCLUDE_DIR=${laszip_2}/include"
    "-DCMAKE_EXE_LINKER_FLAGS=-pthread"
  ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change "@rpath/liblas.3.dylib" "$out/lib/liblas.3.dylib" $out/lib/liblas_c.dylib
  '';

  meta = {
    description = "LAS 1.0/1.1/1.2 ASPRS LiDAR data translation toolset";
    homepage = "https://liblas.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.michelk ];
  };
}
