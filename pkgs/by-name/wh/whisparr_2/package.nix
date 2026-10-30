{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchYarnDeps,
  ffmpeg-headless,
  lib,
  nix-update-script,
  nixosTests,
  nodejs-slim_24,
  sqlite,
  stdenvNoCC,
  writeText,
  yarnBuildHook,
  yarnConfigHook,
}:
let
  inherit (stdenvNoCC.hostPlatform.extensions) sharedLibrary;
  ffprobe = lib.getExe' ffmpeg-headless "ffprobe";
  libsqlite3 = "${lib.getLib sqlite}/lib/libsqlite3${sharedLibrary}";
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule (finalAttrs: {
  pname = "whisparr";
  version = "2.2.0-develop.404";

  src = fetchFromGitHub {
    owner = "Whisparr";
    repo = "Whisparr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k7lJdNxUYs54p0rjjNlQcdvLRf3DCGAOqxw+d9RqXMo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    mv src/NuGet.config NuGet.Config
  '';

  installPath = "${placeholder "out"}/lib/whisparr/bin";

  postInstall = ''
    cp -a ${finalAttrs.passthru.frontend} "$dotnetInstallPath"/UI
    cp ${finalAttrs.passthru.package_info} "$dotnetInstallPath"/../package_info
    ln -sf ${libsqlite3} "$dotnetInstallPath"/libe_sqlite3${sharedLibrary}
    ln -sf ${ffprobe} "$dotnetInstallPath"/ffprobe
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
    "--property:AssemblyConfiguration=v2-develop"
    "--property:AssemblyVersion=${finalAttrs.versionForDotnet}"
    "--property:Copyright=Copyright whisparr.com (${finalAttrs.meta.license.fullName})"
    "--property:EnableAnalyzers=false"
    "--property:RuntimeIdentifier=${rid}"
    "--property:TargetFramework=net10.0"
  ];

  __darwinAllowLocalNetworking = true;
  doCheck = true;

  preCheck = ''
    ln -sf ${libsqlite3} _tests/net10.0/${rid}/libe_sqlite3${sharedLibrary}
    ln -sf ${ffprobe} _tests/net10.0/${rid}/ffprobe
  ''
  + lib.optionalString stdenvNoCC.buildPlatform.isDarwin ''
    export CFFIXED_USER_HOME="$HOME"
  '';

  testProjectFile = [
    "src/NzbDrone.Api.Test/Whisparr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Whisparr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Whisparr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Whisparr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Whisparr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Whisparr.Mono.Test.csproj"
    "src/NzbDrone.Update.Test/Whisparr.Update.Test.csproj"
    "src/Whisparr.Http.Test/Whisparr.Http.Test.csproj"
  ];

  # https://github.com/NixOS/nixpkgs/pull/491217
  dotnetTestFlags = lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    "--environment:DOTNET_SYSTEM_NET_DISABLEIPV6=1"
  ];

  testFilters = [
    "FullyQualifiedName!~NzbDrone.Core.Test.TvTests.RefreshEpisodeServiceFixture."
    "TestCategory!=IntegrationTest"
    "TestCategory!=ManualTest"
  ]
  ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    "FullyQualifiedName!~NzbDrone.Core.Test.Http.HttpProxySettingsProviderFixture."
  ];

  disabledTests = [
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_clear_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_preserve_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.EnvironmentInfo.ReleaseFileVersionAdapterFixture.should_get_version_info"
  ]
  ++ lib.optionals (stdenvNoCC.buildPlatform.isLinux && stdenvNoCC.buildPlatform.isAarch64) [
    "NzbDrone.Core.Test.UpdateTests.UpdatePackageProviderFixture.should_filter_develop_releases_for_v2_develop_branch"
    "NzbDrone.Core.Test.UpdateTests.UpdatePackageProviderFixture.should_filter_stable_releases_for_v2_branch"
  ]
  ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    "NzbDrone.Api.Test.Http.Validation.CertificateValidatorTests.validate_passes_for_valid_pem_certificate"
    "NzbDrone.Api.Test.Http.Validation.CertificateValidatorTests.validate_passes_for_valid_pkcs12_certificate"
    "NzbDrone.Common.Test.Http.SslCertificateLoaderFixture.loadCertificateContext_includes_intermediate_in_chain"
    "NzbDrone.Common.Test.Http.SslCertificateLoaderFixture.loadCertificateContext_loads_pem_chain_with_intermediate"
    "NzbDrone.Common.Test.Http.SslCertificateLoaderFixture.loadCertificateContext_loads_pem_with_separate_key"
    "NzbDrone.Common.Test.Http.SslCertificateLoaderFixture.loadCertificateContext_loads_pkcs12"
    "NzbDrone.Common.Test.Http.SslCertificateLoaderFixture.loadCertificateContext_removes_duplicate_leaf_from_chain"
  ];

  passthru = {
    frontend = stdenvNoCC.mkDerivation {
      inherit (finalAttrs) src version;
      pname = "${finalAttrs.pname}-frontend";

      __structuredAttrs = true;
      strictDeps = true;

      nativeBuildInputs = [
        nodejs-slim_24
        yarnBuildHook
        yarnConfigHook
      ];

      yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${finalAttrs.src}/yarn.lock";
        hash = "sha256-n5AMe4PWvQPNIfmLsL47BA4jem6wzK9uCT7vQESQ/Ys=";
      };

      yarnBuildFlags = lib.cli.toCommandLineGNU { } { env = "production"; };

      installPhase = ''
        runHook preInstall
        mv _output/UI "$out"
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

    tests = { inherit (nixosTests) whisparr_2; };

    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } {
        subpackage = "frontend";
        use-github-releases = true;
        version = "unstable";
        version-regex = ''v(\d+\.\d+\.\d+-develop\.\d+)$'';
      };
    };
  };

  meta = {
    changelog = "https://github.com/Whisparr/Whisparr/releases/tag/${finalAttrs.src.tag}";
    description = "Adult video collection manager for Usenet and BitTorrent users";
    homepage = "https://github.com/Whisparr/Whisparr";
    license = lib.licenses.gpl3Only;
    mainProgram = "Whisparr";
    maintainers = with lib.maintainers; [ connor-grady ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
      fromSource
    ];
  };
})
