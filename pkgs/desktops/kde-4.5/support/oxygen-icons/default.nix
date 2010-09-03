{kde, cmake}:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "04j1csjjji5ffahbcjkcv17agjq5z84czmlpbicv4hnj3rby11nx";

  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    kde = {
      name = "oxygen-icons";
      version = "4.5.1";
    };
  };
}
