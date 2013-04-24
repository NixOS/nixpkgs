{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "10dpbgidn7rwdhm044ydd294dv97hrhaz7jakf1yncszqbhbxksc";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
