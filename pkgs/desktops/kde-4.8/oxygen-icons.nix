{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "973f53b59e31e1e1dca41aa5abf0fc50e9cf0cbee57f156d90c2e754f33cc1b9";

  buildNativeInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
