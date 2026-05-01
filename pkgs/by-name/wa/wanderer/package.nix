{
  lib,
  stdenvNoCC,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  version = "0.19.2";
  src = fetchFromGitHub {
    owner = "Flomp";
    repo = "wanderer";
    rev = "v${version}";
    hash = "sha256-w4DcM+0Rya5Q12VPWjyWXISXb3e0If7CmU5OJhQ0hvg=";
  };

  wanderer = buildGoModule {
    inherit src version;

    pname = "wanderer";
    sourceRoot = "${src.name}/db";
    vendorHash = "sha256-F7ax+Sk4+oaX2tA3/jUuvZPLOjLrpfiL/ZHEf3Cg8Kk=";
  };

  wanderer-web = buildNpmPackage {
    inherit version;
    pname = "wanderer-web";

    src = "${src}/web";
    npmDepsHash = "sha256-nJD5cf+PG8etjl/z3FUtGyygiBgGuhjtFe54buDSqm8=";

    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];

    installPhase = ''
      runHook preinstall

      mkdir -p $out/share
      cp -r build $out/share/build
      cp package*.json $out/share
      cp -r node_modules $out/share

      runHook postinstall
    '';
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "wanderer";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preinstall

    mkdir -p $out/bin
    ln -s ${wanderer}/bin/pocketbase $out/bin/wanderer

    mkdir -p $out/share
    ln -s ${wanderer-web}/share $out/share/web
    cp -r ${src}/db/migrations/initial_data $out/share/initial_data

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Self-hosted trail database for storing and managing GPS tracking data";
    mainProgram = "wanderer";
    homepage = "https://wanderer.to";
    changelog = "https://wanderer.to/changelog/";
    downloadPage = "https://github.com/Flomp/wanderer";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ charludo ];
    inherit (wanderer.meta) platforms;
  };
}
