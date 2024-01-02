{ lib, stdenv, zlib, autoreconfHook, fetchpatch }:

stdenv.mkDerivation {
  pname = "minizip";
  inherit (zlib) src version;

  patches = [
    (fetchpatch {
      name = "CVE-2023-45853.patch";
      url = "https://github.com/madler/zlib/commit/73331a6a0481067628f065ffe87bb1d8f787d10c.patch";
      hash = "sha256-yayfe1g9HsvgMN28WF/MYkH7dGMX4PsK53FcnfL3InM=";
    })
  ];

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";

  meta = {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    inherit (zlib.meta) license homepage;
    platforms = lib.platforms.unix;
  };
}
