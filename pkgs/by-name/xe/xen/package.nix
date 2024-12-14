{
  buildXenPackage,
  python3Packages,
  fetchpatch,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.1";
  patches = [
    (fetchpatch {
      url = "https://lore.kernel.org/xen-devel/e2caa6648a0b6c429349a9826d8fbc4338222482.1733766758.git.andrii.sultanov@cloud.com/raw";
      hash = "sha256-JC1ueXuC1Jdi2gtUsjOHmTeEx56zjotMMLde5vBonxc=";
    })
  ];
  rev = "ccf400846780289ae779c62ef0c94757ff43bb60";
  hash = "sha256-s0eCBCd6ybl+kLtXCC6E1sk++w7txXn/B/Cg5acQFfY=";
}
