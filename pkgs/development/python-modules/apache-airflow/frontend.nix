{ src, mkYarnPackage }:

let
  # HACK: these fields are missing in upstream package.json, but are required by mkYarnPackage
  additionalFields = {
    name = "airflow-frontend";
    version = "1.0.0";
  };
  packageJSON = builtins.fromJSON (builtins.readFile "${src}/package.json");
  patchedPackageJSON = builtins.toFile "package.json" (builtins.toJSON (packageJSON // additionalFields));
in
mkYarnPackage {
  name = "airflow-frontend";
  inherit src;
  packageJSON = patchedPackageJSON;
  doDist = false;

  configurePhase = ''
    cp -r $node_modules node_modules
  '';

  buildPhase = ''
    yarn --offline build
  '';

  installPhase = ''
    mkdir -p $out/static/
    cp -r static/dist $out/static
  '';
}
