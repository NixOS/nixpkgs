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
  version = "4.5.1";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${version}";
    hash = "sha256-qQEthy6YhNAQmdDMyoCIvK8f3Tx25MgqhJZW74CB93E=";
  };

  patches = [
    # cf. https://bugzilla.redhat.com/2224974
    (fetchpatch {
      name = "CVE-2023-40745.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/bdf7b2621c62e04d0408391b7d5611502a752cd0.diff";
      hash = "sha256-HdU02YJ1/T3dnCT+yG03tUyAHkgeQt1yjZx/auCQxyw=";
    })
    # cf. https://bugzilla.redhat.com/2224971
    (fetchpatch {
      name = "CVE-2023-41175.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/965fa243004e012adc533ae8e38db3055f101a7f.diff";
      hash = "sha256-Pvg6JfJWOIaTrfFF0YSREZkS9saTG9IsXnsXtcyKILA=";
    })
    # FreeImage needs this patch
    ./headers.patch
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
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
