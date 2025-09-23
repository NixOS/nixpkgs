{ buildRedist, lib }:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "nvlsm";

  # TODO: includes bin, lib, and share directories.
  outputs = [ "out" ];

  postUnpack = lib.optionalString (finalAttrs.src != null) ''
    nixLog "moving sbin to bin"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/sbin" \
      "$PWD/${finalAttrs.src.name}/bin"
  '';

  brokenAssertions = [
    {
      # The binary files match FHS paths and the configuration files need to be patched.
      message = "contains no references to FHS paths";
      assertion = false;
    }
  ];

  meta = {
    description = "NVLink Subnet Manager";
    longDescription = ''
      A service that originates from NVIDIA InfiniBand switches and has the necessary modifications to effectively manage NVSwitches.
    '';
  };
})
