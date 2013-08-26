{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "03wzq5b9yn7x7qjl6vypsa4jh2km0vz122wyg0pfk6nfl1frgnjf";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
