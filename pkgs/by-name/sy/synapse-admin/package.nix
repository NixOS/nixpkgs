{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
  baseUrl ? null,
  writeShellScriptBin,
}:

mkYarnPackage rec {
  pname = "synapse-admin";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "Awesome-Technologies";
    repo = pname;
    rev = version;
    sha256 = "sha256-3MC5PCEwYfZzJy9AW9nHTpvU49Lk6wbYC4Rcv9J9MEg=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-vpCwPL1B+hbIaVSHtlkGjPAteu9BFNNmCTE66CSyFkg=";
  };

  nativeBuildInputs = [
    (writeShellScriptBin "git" "echo ${version}")
  ];

  NODE_ENV = "production";
  ${if baseUrl != null then "REACT_APP_SERVER" else null} = baseUrl;

  # error:0308010C:digital envelope routines::unsupported
  NODE_OPTIONS = "--openssl-legacy-provider";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn --offline run build

    runHook postBuild
  '';

  distPhase = ''
    runHook preDist

    cp -r deps/synapse-admin/dist $out

    runHook postDist
  '';

  dontFixup = true;
  dontInstall = true;

  meta = with lib; {
    description = "Admin UI for Synapse Homeservers";
    homepage = "https://github.com/Awesome-Technologies/synapse-admin";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [
      mkg20001
      ma27
    ];
  };
}
