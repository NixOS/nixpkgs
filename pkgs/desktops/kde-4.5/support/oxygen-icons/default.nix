{kde, cmake}:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "4c2881683f8d66114ac79a9573498e627146aa647574efb9b8f89f837e1d7b06";

  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    kde.name = "oxygen-icons";
  };
}
