{kde, cmake}:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1fil2rbvy4j47gqpn4xcjvjwxy4yq5mvpwcd5lhp8fdzgsc0jmdn";

  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    kde = {
      name = "oxygen-icons";
      version = "4.5.0";
    };
  };
}
