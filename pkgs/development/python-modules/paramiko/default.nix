{
  callPackage,
  fetchpatch,

  # Dependencies for v3.5.1
  gssapi,
  mock,
  pyasn1,
}:

let
  mkParamiko = args: callPackage ./generic.nix args;
in
rec {
  paramiko_3 = mkParamiko {
    version = "3.5.1";
    hash = "sha256-waaUZBXHxyKetDJw4dojzsuErVL2kh/D44b1X8Ysiyc=";

    extraNativeCheckInputs = [
      mock

      # Also include the optional dependencies
      gssapi
      pyasn1
    ];

    patches = [
      # Fix usage of dsa keys
      # https://github.com/paramiko/paramiko/pull/1606/
      (fetchpatch {
        url = "https://github.com/paramiko/paramiko/commit/18e38b99f515056071fb27b9c1a4f472005c324a.patch";
        hash = "sha256-bPDghPeLo3NiOg+JwD5CJRRLv2VEqmSx1rOF2Tf8ZDA=";
      })
    ];
  };

  paramiko_5 = mkParamiko {
    version = "5.0.0";
    hash = "sha256-zzbM2oGaZ5jkIN7LyDGuMAKSpSmUwpBbup6MBVdTaXA=";
  };

  # Please make sure to update this alias to new major versions once they
  # build successfully on all major platforms.
  #
  # Packages that depend on paramiko should generally use this unversioned
  # alias.
  paramiko = paramiko_5;
}
