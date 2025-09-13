{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_sandbox_dev";
  outputs = [ "out" ];
}
