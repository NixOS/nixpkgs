{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  testers,
  turbo,
  turbo-unwrapped,
  # https://turbo.build/repo/docs/telemetry
  disableTelemetry ? true,
  disableUpdateNotifier ? true,
}:

symlinkJoin {
  pname = "turbo";
  inherit (turbo-unwrapped) version;

  nativeBuildInputs = [ makeBinaryWrapper ];

  paths = [ turbo-unwrapped ];

  postBuild = ''
    wrapProgram $out/bin/turbo \
      ${lib.optionalString disableTelemetry "--set TURBO_TELEMETRY_DISABLED 1"} \
      ${lib.optionalString disableUpdateNotifier "--set TURBO_NO_UPDATE_NOTIFIER 1"}
  '';

  passthru = {
    tests.version = testers.testVersion { package = turbo; };
  };

  meta = {
    inherit (turbo-unwrapped.meta)
      description
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}
