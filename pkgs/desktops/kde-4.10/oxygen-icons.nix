{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1aad2qb9zrjcild5s584q4zz6zc3wgkclv79gnfwkhmy0viqx9l6";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
