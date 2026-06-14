{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  jre,
  gradle,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "traccar";
  version = "6.14.4";

  src = fetchFromGitHub {
    owner = "traccar";
    repo = "traccar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ZwwBPWBz2YfcUYETq9PZdunWiBVuZvFtsx6E+BDPmU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    gradle
  ];

  # required for Darwin builds
  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  doCheck = true;

  traccar-web = buildNpmPackage (finalAttrs': {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) version;

    src = fetchFromGitHub {
      owner = "traccar";
      repo = "traccar-web";
      tag = "v${finalAttrs.version}";
      hash = "sha256-9rftLQIpQVZgkJaQUZ1FORKA2/cJxR5V1JGMAqC7zao=";
    };

    npmDepsHash = "sha256-KC7gPDeGl+M3T7iAUSO5BRUVXZrioeXye1gd85wC/mI=";

    installPhase = ''
      cp -r build $out
    '';
  });

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/traccar}
    cp target/tracker-server.jar $out/traccar.jar

    cp -r target/lib $out

    cp -rt $out schema templates

    makeWrapper ${lib.getExe jre} $out/bin/traccar \
      --add-flags "-jar $out/traccar.jar"

    mkdir -p $out/web
    cp -r ${finalAttrs.traccar-web}/* $out/web

    runHook postInstall
  '';

  passthru = {
    traccar-web = finalAttrs.traccar-web;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "traccar-web"
      ];
    };
  };

  meta = {
    description = "Open source GPS tracking system";
    homepage = "https://www.traccar.org/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    license = lib.licenses.asl20;
    mainProgram = "traccar";
    maintainers = with lib.maintainers; [
      frederictobiasc
      tmarkus
    ];
  };

})
