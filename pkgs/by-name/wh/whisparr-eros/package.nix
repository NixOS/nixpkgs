{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  lib,
  nix-update-script,
  nixosTests,
  nodejs,
  servarr-ffmpeg,
  stdenvNoCC,
  withFFmpeg ? true,
  yarn,
}:
buildDotnetModule (finalAttrs: {
  pname = "whisparr-eros";
  version = "3.4.0.1387";

  src = fetchFromGitHub {
    owner = "Whisparr";
    repo = "Whisparr-eros";
    tag =
      let
        parts = lib.splitVersion finalAttrs.version;
      in
      "v${lib.join "." (lib.init parts)}-release.${lib.last parts}";
    hash = "sha256-r622GxsBaeh7QILpdpWOb71zoljh6lNlC1HoOfip1yQ=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    yarn
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-7l6nWJ5K16sAgdbwg/CgPtT2fqNG+8yBcOcCoOvuqjU=";
  };

  postPatch = "mv src/NuGet.config NuGet.Config";

  postConfigure = ''
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs --build node_modules
  '';

  postBuild = "yarn --offline run build --env production";

  postInstall = ''
    cp -a -- _output/UI "$out/lib/whisparr-eros/UI"
  ''
  + lib.optionalString withFFmpeg ''
    ln -sf ${lib.getExe' servarr-ffmpeg "ffprobe"} "$out/lib/whisparr-eros/ffprobe"
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
    "--property:AssemblyVersion=${finalAttrs.version}"
    "--property:Copyright=Copyright whisparr.com (${finalAttrs.meta.license.fullName})"
    "--property:EnableAnalyzers=false"
    "--property:RuntimeIdentifier=${dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system}"
    "--property:TargetFramework=net10.0"
  ];

  doCheck = true;
  __darwinAllowLocalNetworking = true;

  testProjectFile = [
    "src/NzbDrone.Api.Test/Whisparr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Whisparr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Whisparr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Whisparr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Whisparr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Whisparr.Mono.Test.csproj"
    "src/NzbDrone.Test.Common/Whisparr.Test.Common.csproj"
  ];

  testFilters = [
    "TestCategory!=IntegrationTest"
    "TestCategory!=ManualTest"
  ]
  ++ lib.optional stdenvNoCC.buildPlatform.isDarwin "FullyQualifiedName!~NzbDrone.Core.Test.Http.HttpProxySettingsProviderFixture";

  disabledTests = [
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_clear_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_preserve_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.EnvironmentInfo.ReleaseFileVersionAdapterFixture.should_get_version_info"
  ];

  passthru = {
    tests.whisparr-eros = nixosTests.whisparr-eros;
    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } { version-regex = ''v(\d+\.\d+\.\d+)-release\.(\d+)$''; };
    };
  };

  meta = {
    changelog = "https://github.com/Whisparr/Whisparr-eros/releases/tag/${finalAttrs.src.tag}";
    description = "Adult media collection manager (v3/Eros, Radarr-derived)";
    homepage = "https://github.com/Whisparr/Whisparr-eros";
    license = lib.licenses.gpl3Only;
    mainProgram = "Whisparr";
    maintainers = with lib.maintainers; [ connor-grady ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource
    ];
  };
})
