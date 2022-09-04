{ stdenv
, writeText
, testers
, finalPackage
, runCommand
, passthru ? {}
}: let

in {
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dotnet --info
  '';

  setupHook = writeText "dotnet-setup-hook" ''
    if [ ! -w "$HOME" ]; then
      export HOME=$(mktemp -d) # Dotnet expects a writable home directory for its configuration files
    fi

    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
    export DOTNET_NOLOGO=1 # Disables the welcome message
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
  '';

  passthru = rec {
    tests = {
      version = testers.testVersion {
        package = finalPackage;
      };

      smoke-test = runCommand "dotnet-sdk-smoke-test" {
        nativeBuildInputs = [ finalPackage ];
      } ''
        HOME=$(pwd)/fake-home
        dotnet new console
        dotnet build
        output="$(dotnet run)"
        # yes, older SDKs omit the comma
        [[ "$output" =~ Hello,?\ World! ]] && touch "$out"
      '';
    };
  } // passthru;
}
