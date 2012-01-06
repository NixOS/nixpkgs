{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0c12c72bcf41cfaf03f85fc1ae27e44d8cecac3deb504ab1de4c30f4fc9e3cd0";

  buildNativeInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
