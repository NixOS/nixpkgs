{kde, cmake}:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1mjiim7r88bdsrmf6palx125ig9dn0jp6h3mw35557mx0b0qjbka";

  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    kde = {
      name = "oxygen-icons";
      version = "4.5.2";
    };
  };
}
