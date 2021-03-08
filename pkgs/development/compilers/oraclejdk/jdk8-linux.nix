import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "271";
  sha256.i686-linux = "nC1bRTDj0BPWqClLCfNIqdUn9HywUF8Z/pIV9Kq3LG0=";
  sha256.x86_64-linux = "66eSamg7tlxvThxQLOYkNGxCsA+1Ux3ropbyVgtFLHg=";
  sha256.armv7l-linux = "YZKX0iUf7yqUBUhlpHtVdYw6DBEu7E/pbfcVfK7HMxM=";
  sha256.aarch64-linux = "bFRGnfmYIdXz5b/I8wlA/YiGXhCm/cVoOAU+Hlu4F0I=";
  jceName = "jce_policy-8.zip";
  sha256JCE = "19n5wadargg3v8x76r7ayag6p2xz1bwhrgdzjs9f4i6fvxz9jr4w";
}
