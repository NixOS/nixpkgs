{ src, mkYarnPackage }:

mkYarnPackage {
  name = "airflow-frontend";
  inherit src;
  # Note: The package.json upstream is missing `name` and `version` fields, so it needs to be updated manually.
  # Issue: https://github.com/apache/airflow/issues/25007
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;
  doDist = false;

  configurePhase = ''
    ln -s $node_modules airflow/www/node_modules
  '';

  buildPhase = ''
    yarn --cwd airflow/www --offline --frozen-lockfile build
  '';

  installPhase = ''
    mkdir -p $out/static/
    cp -r airflow/www/static/dist $out/static
  '';
}
