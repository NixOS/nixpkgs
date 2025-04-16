{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openvdb,
}:

openvdb.overrideAttrs (old: rec {
  name = "${old.pname}-${version}";
  version = "11.0.0";
  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    tag = "v${version}";
    hash = "sha256-wDDjX0nKZ4/DIbEX33PoxR43dJDj2NF3fm+Egug62GQ=";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # Fix Clang/LLVM build issues, originally resolved in version 12.0.1:
    # https://github.com/AcademySoftwareFoundation/openvdb/pull/1977
    (fetchpatch {
      name = "fix-clang-template-errors.patch";
      url = "https://github.com/AcademySoftwareFoundation/openvdb/commit/930c3acb8e0c7c2f1373f3a70dc197f5d04dfe74.patch";
      hash = "sha256-LfwzJHa0H6kv2brZx4pJyXqZH04GmEbPrOP3uTnLq+A=";

      # This patch was originally written for 12.0.1, but applies cleanly to 11.0.0
      # with a simple path adjustment.
      postFetch = ''
        substituteInPlace $out --replace-fail "/nanovdb/nanovdb/tools/GridBuilder.h" "/nanovdb/nanovdb/util/GridBuilder.h"
      '';
    })
  ];

  meta = old.meta // {
    license = lib.licenses.mpl20;
  };
})
