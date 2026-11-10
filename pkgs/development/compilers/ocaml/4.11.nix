import ./generic.nix {
  major_version = "4";
  minor_version = "11";
  patch_version = "2";
  sha256 = "1m3wrgkkv3f77wvcymjm0i2srxzmx62y6jln3i0a2px07ng08l9z";
  patches = [
    ./glibc-2.34-for-ocaml-4.10-and-11.patch
  ];
}
