{ kde, cmake }:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "4736af7eef8c0defa8f5ae997ac85e0a19c4d1af9a9e963b2434317c5408ab86";

  buildInputs = [ cmake ];
  
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
    kde.name = "oxygen-icons";
  };
}
