{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "87010a208f6860429d78c0d518a4f70c450b9c199900076d0aa232de8ae6452e";

  buildNativeInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
