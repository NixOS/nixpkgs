{
  lib,
  runCommand,
  python3,
  callPackage,
  dotnetCorePackages,
  sdk,
}:

let
  resolver = callPackage ../workload-manifest-resolver { inherit sdk; };
  withWasm = sdk.withWorkloads [ "wasm-tools" ];
  otherSdk =
    if lib.versions.major sdk.version == "10" then
      dotnetCorePackages.sdk_11_0
    else
      dotnetCorePackages.sdk_10_0;
  nugetSource = dotnetCorePackages.mkNugetSource {
    name = "dotnet-workload-test-nuget-source-${sdk.version}";
    deps = sdk.packages;
  };
  mkDirectTest =
    name: dotnet:
    runCommand "dotnet-workload-${name}-test-${sdk.version}"
      {
        propagatedSandboxProfile = toString sdk.__propagatedSandboxProfile;
      }
      ''
        export HOME="$TMPDIR/home"
        export DOTNET_CLI_TELEMETRY_OPTOUT=1
        export DOTNET_NOLOGO=1
        export NUGET_PACKAGES="$TMPDIR/nuget"
        unset DOTNETSDK_WORKLOAD_PACK_ROOTS
        mkdir -p "$HOME"
        cp ${./wasm}/* .
        chmod u+w test.csproj
        substituteInPlace test.csproj \
          --replace-fail "@targetFramework@" "${lib.versions.majorMinor sdk.version}"
        cat > global.json <<EOF
        {
          "sdk": {
            "version": "${sdk.version}",
            "rollForward": "disable",
            "allowPrerelease": true
          }
        }
        EOF
        cat > NuGet.Config <<EOF
        <configuration>
          <packageSources>
            <clear />
            <add key="offline" value="${nugetSource}/lib" />
          </packageSources>
        </configuration>
        EOF
        test "$(${dotnet}/bin/dotnet --version)" = "${sdk.version}"
        ${dotnet}/bin/dotnet build --output "$out"
        test -f "$out/test.dll"
      '';
in
{
  generator = runCommand "dotnet-workload-generator-tests" { nativeBuildInputs = [ python3 ]; } ''
    mkdir tests
    cp ${../generate-workload-data.py} generate-workload-data.py
    cp ${./test-workloads.py} tests/test-workloads.py
    python3 tests/test-workloads.py
    touch "$out"
  '';

  resolver =
    runCommand "dotnet-workload-resolver-tests-${sdk.version}"
      {
        nativeBuildInputs = [ python3 ];
        propagatedSandboxProfile = toString sdk.__propagatedSandboxProfile;
      }
      ''
        python3 ${./test-resolver.py} ${resolver}/bin/dotnet-workload-manifest-resolver
        touch "$out"
      '';

  wasm = withWasm.tests.wasm;
  direct = mkDirectTest "direct-wrapper" withWasm;
  combined = mkDirectTest "combined" (
    dotnetCorePackages.combinePackages [
      withWasm
      otherSdk
    ]
  );
}
