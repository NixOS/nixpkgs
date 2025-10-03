{
  backendStdenv,
  buildRedist,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcudla";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "stubs"
  ];

  autoPatchelfIgnoreMissingDeps = lib.optionals backendStdenv.hasJetsonCudaCapability [
    "libnvcudla.so"
  ];

  passthru.platformAssertions = [
    {
      message = "Only Xavier (7.2) and Orin (8.7) Jetson devices are supported";
      assertion =
        let
          inherit (backendStdenv) hasJetsonCudaCapability requestedJetsonCudaCapabilities;
        in
        hasJetsonCudaCapability
        -> (lib.subtractLists [ "7.2" "8.7" ] requestedJetsonCudaCapabilities == [ ]);
    }
  ];
}
