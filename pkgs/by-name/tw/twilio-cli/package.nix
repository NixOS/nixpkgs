{
  lib,
  stdenvNoCC,
  nodejs-slim,
  fetchzip,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "twilio-cli";
  version = "6.2.1";

  src = fetchzip {
    url = "https://twilio-cli-prod.s3.amazonaws.com/twilio-v${finalAttrs.version}/twilio-v${finalAttrs.version}.tar.gz";
    hash = "sha256-yxtMpmPB3w+28aU0G4hAF3I+uijdI5yavqHlthZ9eIs=";
  };

  buildInputs = [ nodejs-slim ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/twilio-cli
    cp -R . $out/libexec/twilio-cli
    ln -s $out/libexec/twilio-cli/bin/run $out/bin/twilio

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Unleash the power of Twilio from your command prompt";
    homepage = "https://github.com/twilio/twilio-cli";
    changelog = "https://github.com/twilio/twilio-cli/blob/${finalAttrs.version}/CHANGES.md";
    license = licenses.mit;
    maintainers = [ ];
    platforms = nodejs-slim.meta.platforms;
    mainProgram = "twilio";
  };
})
