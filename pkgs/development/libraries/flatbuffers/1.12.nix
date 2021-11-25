{ callPackage, fetchpatch, lib, stdenv }:

callPackage ./generic.nix {
  version = "1.12.0";
  sha256 = "0f7xd66vc1lzjbn7jzd5kyqrgxpsfxi4zc7iymhb5xrwyxipjl1g";

  patches = [
    (fetchpatch {
      # Fixed a compilation error with GCC 10.0 to 11.0. June 1, 2020.
      # Should be included in the next release after 1.12.0
      url = "https://github.com/google/flatbuffers/commit/988164f6e1675bbea9c852e2d6001baf4d1fcf59.patch";
      sha256 = "0d8c2bywqmkhdi0a41cry85wy4j58pl0vd6h5xpfqm3fr8w0mi9s";
      excludes = [ "src/idl_gen_cpp.cpp" ];
    })
    (fetchpatch {
      # Fixed a compilation error with GCC 10.0 to 11.0. July 6, 2020.
      # Should be included in the next release after 1.12.0
      url = "https://github.com/google/flatbuffers/pull/6020/commits/44c7a4cf439b0a298720b5a448bcc243a882b0c9.patch";
      sha256 = "126xwkvnlc4ignjhxv9jygfd9j6kr1jx39hyk0ddpcmvzfqsccf4";
    })
  ];

  preConfigure = lib.optionalString stdenv.buildPlatform.isDarwin ''
    rm BUILD
  '';
}
