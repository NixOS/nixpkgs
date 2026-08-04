{
  src,
  version,
  lib,
  stdenv,
  nodejs,
  yarn,
  yarnConfigHook,
  yarnBuildHook,
  fetchYarnDeps,
}:

stdenv.mkDerivation {
  pname = "traggo-ui";
  inherit version;

  src = "${src}/ui";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/ui/yarn.lock";
    hash = "sha256-BDQ7MgRWBRQQfjS5UCW3KJ0kJrkn4g9o4mU0ZH+vhX0=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    yarnConfigHook
    yarnBuildHook
  ];

  env = {
    # react-scripts 3 runs on webpack 4, which hashes with MD4, rejected by
    # OpenSSL 3. Same workaround as upstream CI.
    NODE_OPTIONS = "--openssl-legacy-provider";
    APOLLO_TELEMETRY_DISABLED = "1";
  };

  # src/gql/__generated__ is gitignored, so codegen has to run here. It reads
  # the schema from ../schema.graphql relative to ui/.
  preBuild = ''
    cp ${src}/schema.graphql ../schema.graphql
    yarn --offline generate
  '';

  installPhase = ''
    runHook preInstall
    cp -r build $out
    runHook postInstall
  '';

  meta = {
    description = "Web UI for traggo";
    homepage = "https://traggo.net";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ elnudev ];
  };
}
