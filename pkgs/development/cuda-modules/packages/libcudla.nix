{
  backendStdenv,
  buildRedist,
  cudaOlder,
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

  autoPatchelfIgnoreMissingDeps = [
    "libnvcudla.so"
  ]
  ++ lib.optionals (cudaOlder "12") [
    "libcuda.so.1"
    "libnvdla_runtime.so"
  ];

  meta.problems =
    lib.optionalAttrs (lib.subtractLists [ "7.2" "8.7" ] backendStdenv.cudaCapabilities != [ ])
      {
        unsupportedJetsonDevice = {
          kind = "unsupported";
          message = "Only Xavier (7.2) and Orin (8.7) Jetson devices are supported.";
        };
      };
}
