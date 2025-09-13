{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_crt";

  outputs = [ "out" ];

  # There's a comment with a reference to /usr
  allowFHSReferences = true;
}
