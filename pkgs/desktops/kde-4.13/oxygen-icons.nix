{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1p1lsib9vi2z0n0k6ff8xijsmhdf5xhh42c06y2jxxsrh6r8zvky";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
