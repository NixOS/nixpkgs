{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, nix-update-script

, autoreconfHook
, pkg-config
, sphinx

, libdeflate
, libjpeg
, xz
, zlib

  # for passthru.tests
, libgeotiff
, python3Packages
, imagemagick
, graphicsmagick
, gdal
, openimageio
, freeimage
}:

stdenv.mkDerivation rec {
  pname = "libtiff";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${version}";
    hash = "sha256-KG6rB940JMjFUTAgtkzg+Zh75gylPY6Q7/4gEbL0Hcs=";
  };

  patches = [
    # FreeImage needs this patch
    ./headers.patch
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
    (fetchpatch {
      name = "CVE-2022-48281.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/d1b6b9c1b3cae2d9e37754506c1ad8f4f7b646b5.diff";
      sha256 = "sha256-FWUlyJyHXac6fuM5f9PG33kcF5Bm4fyFmYnaDal46iM=";
    })
    (fetchpatch {
      name = "CVE-2023-0800.CVE-2023-0801.CVE-2023-0802.CVE-2023-0803.CVE-2023-0804.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/33aee1275d9d1384791d2206776eb8152d397f00.patch";
      sha256 = "sha256-wNSa1D9EWObTs331utjIKgo9p9PUWqTM54qG+1Hhm1A=";
    })
    (fetchpatch {
      name = "CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.prerequisite-0.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/9c22495e5eeeae9e00a1596720c969656bb8d678.patch";
      sha256 = "sha256-NTs+dCUweKddQDzJLqbdIdvNbaSweGG0cSVt57tntoI=";
    })
    (fetchpatch {
      name = "CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.prerequisite-1.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/d63de61b1ec3385f6383ef9a1f453e4b8b11d536.patch";
      includes = [ "tools/tiffcrop.c" ];
      sha256 = "sha256-VHg5aAcHKwRkDFDyC1rLjCjj1rMzcq/2SUR/r1fQubQ=";
    })
    (fetchpatch {
      name = "CVE-2023-0795.CVE-2023-0796.CVE-2023-0797.CVE-2023-0798.CVE-2023-0799.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/afaabc3e50d4e5d80a94143f7e3c997e7e410f68.patch";
      sha256 = "sha256-9+oXKVJEeaIuMBdtvhNlUBNpw9uzg31s+zxt4GJo6Lo=";
    })
  ];

  postPatch = ''
    mv VERSION VERSION.txt
  '';

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/tif_config.h $dev_private
    moveToOutput include/tif_dir.h $dev_private
    moveToOutput include/tif_hash_set.h $dev_private
    moveToOutput include/tiffiop.h $dev_private
  '';

  # If you want to change to a different build system, please make
  # sure cross-compilation works first!
  nativeBuildInputs = [ autoreconfHook pkg-config sphinx ];

  # TODO: opengl support (bogus configure detection)
  propagatedBuildInputs = [
    libdeflate
    libjpeg
    xz
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests = {
      inherit libgeotiff imagemagick graphicsmagick gdal openimageio freeimage;
      inherit (python3Packages) pillow imread;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/v${version}.html";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
