# TODO: switch to stdenvNoCC
{ stdenv
, lib
, writeText
, testers
, runCommand
}: type: args: stdenv.mkDerivation (finalAttrs: args // {
  doInstallCheck = true;

  # TODO: this should probably be postInstallCheck
  # TODO: send output to /dev/null
  installCheckPhase = args.installCheckPhase or "" + ''
    $out/bin/dotnet --info
  '';

  # TODO: move this to sdk section?
  setupHook = writeText "dotnet-setup-hook" (''
    if [ ! -w "$HOME" ]; then
      export HOME=$(mktemp -d) # Dotnet expects a writable home directory for its configuration files
    fi

    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
    export DOTNET_NOLOGO=1 # Disables the welcome message
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_WORKLOAD_INTEGRITY_CHECK=1 # Skip integrity check on first run, which fails due to read-only directory
  '' + args.setupHook or "");

} // lib.optionalAttrs (type == "sdk") {
  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };

      console = runCommand "dotnet-test-console" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } ''
        HOME=$(pwd)/fake-home
        dotnet new nugetconfig
        dotnet nuget disable source nuget
        dotnet new console -n test -o .
        output="$(dotnet run)"
        # yes, older SDKs omit the comma
        [[ "$output" =~ Hello,?\ World! ]] && touch "$out"
      '';

      single-file = let build = runCommand "dotnet-test-build-single-file" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } ''
        HOME=$(pwd)/fake-home
        dotnet new nugetconfig
        dotnet nuget disable source nuget
        dotnet nuget add source ${finalAttrs.finalPackage.packages}
        dotnet new console -n test -o .
        dotnet publish --use-current-runtime -p:PublishSingleFile=true -o $out
      ''; in runCommand "dotnet-test-run-single-file" {} ''
        output="$(${build}/test)"
        # yes, older SDKs omit the comma
        [[ "$output" =~ Hello,?\ World! ]] && touch "$out"
      '';
    } // args.passthru.tests or {};
  } // args.passthru or {};
})
