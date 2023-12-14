{ lib
, stdenv
, fetchFromGitLab
, fetchpatch

, autoreconfHook
, pkg-config
, sphinx

, libdeflate
, libjpeg
, xz
, zlib
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
    ./headers-4.5.patch
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version-4.5.patch
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

  propagatedBuildInputs = [
    libdeflate
    libjpeg
    xz
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/v${version}.html";
    # XXX not enabled for now to keep hydra builds running,
    # but we have to keep an eye on security updates in supported version
    #knownVulnerabilities = [ "support for version 4.5 ended in Sept 2023" ];
    maintainers = with maintainers; [ yarny ];
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
