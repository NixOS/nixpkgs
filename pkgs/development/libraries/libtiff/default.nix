{ lib, stdenv
, fetchurl
, fetchpatch

, autoreconfHook
, pkg-config

, libdeflate
, libjpeg
, xz
, zlib
}:

#FIXME: fix aarch64-darwin build and get rid of ./aarch64-darwin.nix

stdenv.mkDerivation rec {
  pname = "libtiff";
  version = "4.3.0";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "1j3snghqjbhwmnm5vz3dr1zm68dj15mgbx1wqld7vkl7n2nfaihf";
  };

  patches = [
    # FreeImage needs this patch
    ./headers.patch
    (fetchpatch {
      name = "CVE-2022-22844.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/03047a26952a82daaa0792957ce211e0aa51bc64.patch";
      sha256 = "0cfih55f5qpc84mvlwsffik80bgz6drkflkhrdyqq8m84jw3mbwb";
    })
    (fetchpatch {
      name = "CVE-2022-0561.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/eecb0712f4c3a5b449f70c57988260a667ddbdef.patch";
      sha256 = "0m57fdxyvhhr9cc260lvkkn2g4zr4n4v9nricc6lf9h6diagd7mk";
    })
    (fetchpatch {
      name = "CVE-2022-0562.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/561599c99f987dc32ae110370cfdd7df7975586b.patch";
      sha256 = "0ycirjjc1vigj03kwjb92n6jszsl9p17ccw5hry7lli9gxyyr0an";
    })
  ];

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/tif_dir.h $dev_private
    moveToOutput include/tif_config.h $dev_private
    moveToOutput include/tiffiop.h $dev_private
  '';

  # If you want to change to a different build system, please make
  # sure cross-compilation works first!
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  propagatedBuildInputs = [ libjpeg xz zlib ]; #TODO: opengl support (bogus configure detection)

  buildInputs = [ libdeflate ]; # TODO: move all propagatedBuildInputs to buildInputs.

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/v${version}.html";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
