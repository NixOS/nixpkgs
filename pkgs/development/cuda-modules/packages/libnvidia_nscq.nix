{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvidia_nscq";

  outputs = [
    "out"
    "lib"
  ];

  allowFHSReferences = true;
}
