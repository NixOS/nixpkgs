{kde, cmake}:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1qqdmg4q145gac23b0kyarslfwnlkngcxm6x37b03vr1srccycmx";

  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    kde.module = "oxygen-icons";
  };
}
