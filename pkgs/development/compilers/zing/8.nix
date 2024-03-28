{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.02.0.0";
      jdkVersion = "8.0.402";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk8.0.402-linux_aarch64.tar.gz";
      hash =
        "sha512-lqxLDbAoJrYMWKOEA7OS4dgwVdLgcBQuVPUneMN79cq5AUgs/geJywNSWxOanGvIh7E15LkUPRTzdABUGyBu4w==";
    };
    x86_64-linux = {
      version = "24.02.0.0";
      jdkVersion = "8.0.402";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk8.0.402-linux_x64.tar.gz";
      hash =
        "sha512-3GB5BGWlnd9RBRLPtAlwSkEN+WvCCudF/eyOQMgqgUd1c2+2dgWPu3yQaLuiEyWcyQLESKTUeSvnHTc64yF3YA==";
    };
  };
}
