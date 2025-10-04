{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  version = "0.18.2";
  src = fetchFromGitHub {
    owner = "Flomp";
    repo = "wanderer";
    rev = "v${version}";
    hash = "sha256-iz6OgGSxU8YuEoh3sCSQv/hszrxQfdACwc3LsB7wctI=";
  };

  wanderer = buildGoModule {
    inherit src version;

    pname = "wanderer";
    sourceRoot = "${src.name}/db";
    vendorHash = "sha256-P8FOeQOl3601hTjq2gFcQyIu3Lt1gO1MOWoiLhjOs0A=";
  };

  wanderer-web = buildNpmPackage {
    inherit version;
    pname = "wanderer-web";

    src = "${src}/web";
    npmDepsHash = "sha256-rR+df6IS/jnmugotrPC8im73bLrTsF3onp2/x/m9cag=";

    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];

    installPhase = ''
      mkdir -p $out/share
      cp -r build $out/share/build
      cp package*.json $out/share
      cp -r node_modules $out/share
    '';
  };
in
stdenv.mkDerivation {
  inherit version;
  pname = "wanderer";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${wanderer}/bin/pocketbase $out/bin/wanderer

    mkdir -p $out/share
    ln -s ${wanderer-web}/share $out/share/web
    cp -r ${src}/db/migrations/initial_data $out/share/initial_data
  '';

  meta = with lib; {
    description = "wanderer is a self-hosted trail database. Save your adventures!";
    mainProgram = "wanderer";
    homepage = "https://wanderer.to";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ charludo ];
  };
}
