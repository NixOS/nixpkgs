{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvsdm";

  # TODO(@connorbaker): Not sure this is the correct set of outputs.
  outputs = [ "out" ];

  allowFHSReferences = true;

  meta = {
    description = "NVSwitch Device Monitoring API";
    homepage = "https://github.com/NVIDIA/nvsdm";
    changelog = "https://github.com/NVIDIA/nvsdm/releases";
  };
}
