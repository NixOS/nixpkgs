{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.3.0";
  branch = "2.3";
  revision = "v${version}";
  sha256 = "08plxrnfl33sn2vh5nwbsngyv6b1sfpplvx881crm1v1ai10m2lz";

  patches = [
    (fetchpatch {
      name = "CVE-2018-7648.patch";
      url = "https://github.com/uclouvain/openjpeg/commit/cc3824767bde397fedb8a1ae4786a222ba860c8d.patch";
      sha256 = "1j5nxmlgyfkxldk2f1ij6h850xw45q3b5brxqa04dxsfsv8cdj5j";
    })
    (fetchpatch {
      name = "CVE-2017-17480+CVE-2018-18088.patch";
      url = "https://github.com/uclouvain/openjpeg/commit/92023cd6c377e0384a7725949b25655d4d94dced.patch";
      sha256 = "0rrxxqcp3vjkmvywxj9ac766m3fppy0x0nszrkf8irrqy1gnp38k";
    })
  ];
})
