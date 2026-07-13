{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nix-update-script,
  nixosTests,
  nodejs_24,
  servarr-ffmpeg,
  stdenvNoCC,
  withFFmpeg ? true,
  writeText,
  yarnBuildHook,
  yarnConfigHook,
}:
buildDotnetModule (finalAttrs: {
  pname = "whisparr-eros";
  version = "3.6.0-release.1660";

  src = fetchFromGitHub {
    owner = "Whisparr";
    repo = "Whisparr-Eros";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3v7D/QfC9oEb7rw/hAtAB7PbF5adsPCSPr5eBg4NMew=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = "mv src/NuGet.config NuGet.Config";

  installPath = "${placeholder "out"}/lib/${finalAttrs.pname}/bin";

  postInstall = ''
    cp -a ${finalAttrs.passthru.frontend} $dotnetInstallPath/UI
    cp ${finalAttrs.passthru.package_info} $dotnetInstallPath/../package_info
  ''
  + lib.optionalString withFFmpeg ''
    ln -sf ${lib.getExe' servarr-ffmpeg "ffprobe"} $dotnetInstallPath/ffprobe
  '';

  dotnet-sdk = dotnetCorePackages.sdk_10_0_1xx;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  nugetDeps = ./deps.json;

  projectFile = [
    "src/NzbDrone.Console/Whisparr.Console.csproj"
    "src/NzbDrone.Mono/Whisparr.Mono.csproj"
  ];

  executables = [ "Whisparr" ];

  dotnetFlags = [
    "--property:AssemblyConfiguration=release"
    "--property:AssemblyVersion=${finalAttrs.versionForDotnet}"
    "--property:Copyright=Copyright whisparr.com (${finalAttrs.meta.license.fullName})"
    "--property:EnableAnalyzers=false"
    "--property:TargetFramework=net10.0"
  ];

  __darwinAllowLocalNetworking = true;
  doCheck = true;

  testProjectFile = [
    "src/NzbDrone.Api.Test/Whisparr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Whisparr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Whisparr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Whisparr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Whisparr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Whisparr.Mono.Test.csproj"
    "src/NzbDrone.Update.Test/Whisparr.Update.Test.csproj"
  ];

  testFilters = [
    "TestCategory!=IntegrationTest"
    "TestCategory!=ManualTest"
  ];

  disabledTests = [
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_clear_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_preserve_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.EnvironmentInfo.ReleaseFileVersionAdapterFixture.should_get_version_info"
  ];

  passthru = {
    frontend = stdenvNoCC.mkDerivation {
      inherit (finalAttrs) src version;
      pname = "${finalAttrs.pname}-frontend";

      __structuredAttrs = true;
      strictDeps = true;

      nativeBuildInputs = [
        nodejs_24
        yarnBuildHook
        yarnConfigHook
      ];

      yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${finalAttrs.src}/yarn.lock";
        hash = "sha256-pRGnFxa0sSyPuFxNNvuiOtlw5oCEMi7Y+UVY8COEfxU=";
      };

      yarnBuildFlags = [ "--env=production" ];

      installPhase = ''
        runHook preInstall
        mv _output/UI $out
        runHook postInstall
      '';
    };

    package_info = writeText "${finalAttrs.pname}-package_info" (
      lib.generators.toKeyValue { } {
        PackageAuthor = "[NixOS](https://nixos.org)";
        PackageVersion = finalAttrs.version;
        UpdateMethod = "External";
        UpdateMethodMessage = "Whisparr is managed by Nix. Update it through your system configuration.";
      }
    );

    tests.whisparr-eros = nixosTests.whisparr-eros;

    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } {
        subpackage = "frontend";
        use-github-releases = true;
        version-regex = ''v(\d+\.\d+\.\d+-release\.\d+)$'';
      };
    };
  };

  meta = {
    changelog = "https://github.com/Whisparr/Whisparr-Eros/releases/tag/${finalAttrs.src.tag}";
    description = "Adult media collection manager (v3/Eros, Radarr-derived)";
    homepage = "https://github.com/Whisparr/Whisparr-Eros";
    license = lib.licenses.gpl3Only;
    mainProgram = "Whisparr";
    maintainers = with lib.maintainers; [ connor-grady ];
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
      fromSource
    ];
    platforms = lib.platforms.unix;
  };
})
