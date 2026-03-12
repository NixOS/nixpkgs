{
  lib,
  fetchurl,
  stdenvNoCC,
  autoPatchelfHook,
  unzip,
  stdenv,
  zlib,
}:

let
  featureBand = "10.0.100";
  workloadSetVersion = "10.0.103";
  androidManifestVersion = "36.1.30";
  runtimeVersion = "10.0.3";

  androidManifest = builtins.toFile "dotnet-android-workload-manifest.json" ''
    {
      "version": "${androidManifestVersion}",
      "workloads": {
        "android": {
          "description": ".NET SDK Workload for building Android applications.",
          "packs": [
            "Microsoft.Android.Sdk.net10",
            "Microsoft.Android.Ref.36",
            "Microsoft.Android.Runtime.36.android",
            "Microsoft.Android.Runtime.Mono.36.android-arm",
            "Microsoft.Android.Runtime.Mono.36.android-arm64",
            "Microsoft.Android.Runtime.Mono.36.android-x86",
            "Microsoft.Android.Runtime.Mono.36.android-x64",
            "Microsoft.Android.Runtime.CoreCLR.36.android-arm64",
            "Microsoft.Android.Runtime.CoreCLR.36.android-x64",
            "Microsoft.Android.Runtime.NativeAOT.36.android-arm64",
            "Microsoft.Android.Runtime.NativeAOT.36.android-x64"
          ],
          "platforms": [ "win-x64", "win-arm64", "linux-x64", "linux-arm64", "osx-x64", "osx-arm64" ],
          "extends": [
            "microsoft-net-runtime-android",
            "microsoft-net-runtime-android-aot"
          ]
        }
      },
      "packs": {
        "Microsoft.Android.Sdk.net10": {
          "kind": "sdk",
          "version": "${androidManifestVersion}",
          "alias-to": {
            "osx-x64": "Microsoft.Android.Sdk.Darwin",
            "osx-arm64": "Microsoft.Android.Sdk.Darwin",
            "win-x86": "Microsoft.Android.Sdk.Windows",
            "win-x64": "Microsoft.Android.Sdk.Windows",
            "win-arm64": "Microsoft.Android.Sdk.Windows",
            "linux-x64": "Microsoft.Android.Sdk.Linux",
            "linux-arm64": "Microsoft.Android.Sdk.Linux"
          }
        },
        "Microsoft.Android.Ref.36": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.36.android": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.Mono.36.android-arm": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.Mono.36.android-arm64": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.Mono.36.android-x86": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.Mono.36.android-x64": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.CoreCLR.36.android-arm64": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.CoreCLR.36.android-x64": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.NativeAOT.36.android-arm64": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        },
        "Microsoft.Android.Runtime.NativeAOT.36.android-x64": {
          "kind": "framework",
          "version": "${androidManifestVersion}"
        }
      }
    }
  '';

  androidManifestTargets = builtins.toFile "dotnet-android-workload-manifest.targets" ''
    <Project>
      <ImportGroup Condition=" '$(TargetPlatformIdentifier)' == 'android' ">
        <Import Project="Sdk.targets" Sdk="Microsoft.Android.Sdk.net10"
            Condition=" $([MSBuild]::VersionEquals($(TargetFrameworkVersion), '10.0')) " />
        <Import Project="Eol.targets" Sdk="Microsoft.Android.Sdk.net10"
            Condition=" $([MSBuild]::VersionLessThanOrEquals($(TargetFrameworkVersion), '9.0')) " />
      </ImportGroup>

      <ItemGroup Condition=" '$(TargetFrameworkIdentifier)' == '.NETCoreApp' and $([MSBuild]::VersionGreaterThanOrEquals($(TargetFrameworkVersion), '10.0')) ">
        <SdkSupportedTargetPlatformIdentifier Include="android" DisplayName="Android" />
      </ItemGroup>
    </Project>
  '';

  androidWorkloadDependencies = builtins.toFile "dotnet-android-workload-dependencies.json" ''
    {
      "microsoft.net.sdk.android": {
        "workload": {
          "alias": [
            "android"
          ],
          "version": "${androidManifestVersion}"
        },
        "jdk": {
          "version": "[17.0,22.0)",
          "recommendedVersion": "17.0.14"
        }
      }
    }
  '';

  workloadSet = builtins.toFile "dotnet-android-workloadset.json" ''
    {
      "Microsoft.NET.Workload.Emscripten.Current": "${workloadSetVersion}/${featureBand}",
      "Microsoft.NET.Sdk.Android": "${androidManifestVersion}/${featureBand}",
      "Microsoft.NET.Workload.Mono.ToolChain.Current": "${workloadSetVersion}/${featureBand}"
    }
  '';

  installState = builtins.toFile "dotnet-android-install-state.json" ''
    {
      "useWorkloadSets": true,
      "workloadVersion": "${workloadSetVersion}"
    }
  '';

  fetchNupkg =
    {
      pname,
      version,
      hash,
    }:
    fetchurl {
      name = "${pname}.${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${pname}/${version}";
      inherit hash;
    };

  packSpecs = [
    {
      logicalId = "Microsoft.Android.Sdk.net10";
      resolvedId = "Microsoft.Android.Sdk.Linux";
      version = androidManifestVersion;
      kind = 0;
      hash = "sha256-nvGU8GhpLQqGNRTOv+aqmOt9/KJDpRFfSyIE1Mc49nY=";
    }
    {
      logicalId = "Microsoft.Android.Ref.36";
      resolvedId = "Microsoft.Android.Ref.36";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-KtP0rxFugbr5xE8vTxR89+lrPylExpWgHRBF9KgNgDQ=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.36.android";
      resolvedId = "Microsoft.Android.Runtime.36.android";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-2PuuGyKgJcGBodfL9lmJFZ9QItzPsYmLDrxRVSHEYzA=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.Mono.36.android-arm";
      resolvedId = "Microsoft.Android.Runtime.Mono.36.android-arm";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-1IO+RbduocWf6GzPy4GDc0kBlYDxC+zFxNnbiIx+sEs=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.Mono.36.android-arm64";
      resolvedId = "Microsoft.Android.Runtime.Mono.36.android-arm64";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-JvaERNgGGRE7VLpb2jC2bgyICTVngsoG5V/v4pOenKE=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.Mono.36.android-x86";
      resolvedId = "Microsoft.Android.Runtime.Mono.36.android-x86";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-CJgHxC3Nl2p6lhrYO1RQxd3f/4xIbmozwbmBoBd3ycs=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.Mono.36.android-x64";
      resolvedId = "Microsoft.Android.Runtime.Mono.36.android-x64";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-j4122Ssi8HZvDoTlHsednKSSO3xAoOajdzasSG/lJGc=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.CoreCLR.36.android-arm64";
      resolvedId = "Microsoft.Android.Runtime.CoreCLR.36.android-arm64";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-g4cUtHbhz5By8OPVS9xEcuN/2H2pjwz3VKDonjYHFPo=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.CoreCLR.36.android-x64";
      resolvedId = "Microsoft.Android.Runtime.CoreCLR.36.android-x64";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-TamEzHRbpUq2dDPSpb5PQ4MQsQec677HFt6Jsz/JOBk=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.NativeAOT.36.android-arm64";
      resolvedId = "Microsoft.Android.Runtime.NativeAOT.36.android-arm64";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-ElgM3q15ZBMPA2xtS3NC5ckPHKwPNQ9P24BAUxMiz3s=";
    }
    {
      logicalId = "Microsoft.Android.Runtime.NativeAOT.36.android-x64";
      resolvedId = "Microsoft.Android.Runtime.NativeAOT.36.android-x64";
      version = androidManifestVersion;
      kind = 1;
      hash = "sha256-hxRvHVRk27M5wcmKZz3sK/kP8qvyTkK65i3H90W1UlQ=";
    }
    {
      logicalId = "Microsoft.NET.Runtime.MonoAOTCompiler.Task.net10";
      resolvedId = "Microsoft.NET.Runtime.MonoAOTCompiler.Task";
      version = runtimeVersion;
      kind = 0;
      hash = "sha256-A/VmHVb/JYDJXMXAnuRpUxFmocW0JFZzZoJz3856Vi8=";
    }
    {
      logicalId = "Microsoft.NET.Runtime.MonoTargets.Sdk.net10";
      resolvedId = "Microsoft.NET.Runtime.MonoTargets.Sdk";
      version = runtimeVersion;
      kind = 0;
      hash = "sha256-tv+lJhvfYbvKz5RheJGrRqs65eDJuIJTZc8MIyz2Y+g=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.Mono.net10.android-arm";
      resolvedId = "Microsoft.NETCore.App.Runtime.Mono.android-arm";
      version = runtimeVersion;
      kind = 1;
      hash = "sha256-viOz/k5+W1UBeomQgHuO8k5KgE4P0vjBFpyIeKZhgco=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.Mono.net10.android-arm64";
      resolvedId = "Microsoft.NETCore.App.Runtime.Mono.android-arm64";
      version = runtimeVersion;
      kind = 1;
      hash = "sha256-odtd9+1OgyFFGFZ3f8zwR5IO6LDKTqwoGDbuMxJxim8=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.Mono.net10.android-x86";
      resolvedId = "Microsoft.NETCore.App.Runtime.Mono.android-x86";
      version = runtimeVersion;
      kind = 1;
      hash = "sha256-/0f+rM9dhUIjB7IM00mhGXOogrPLXyF0N2N2oHarJTQ=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.Mono.net10.android-x64";
      resolvedId = "Microsoft.NETCore.App.Runtime.Mono.android-x64";
      version = runtimeVersion;
      kind = 1;
      hash = "sha256-3SHcqQa2vT1Uhztrub/bXlo3+AUSv9esOD6q+EwF6HM=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.AOT.Cross.net10.android-arm";
      resolvedId = "Microsoft.NETCore.App.Runtime.AOT.linux-x64.Cross.android-arm";
      version = runtimeVersion;
      kind = 0;
      hash = "sha256-3cs37s4VuTs13JbKatDlutpXiignTe2rNFNT7QVTuC0=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.AOT.Cross.net10.android-arm64";
      resolvedId = "Microsoft.NETCore.App.Runtime.AOT.linux-x64.Cross.android-arm64";
      version = runtimeVersion;
      kind = 0;
      hash = "sha256-cKXLVFVrkw1TQLx2C7a1GfPH+CKhGmEhoXYxtgt5Pqc=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.AOT.Cross.net10.android-x86";
      resolvedId = "Microsoft.NETCore.App.Runtime.AOT.linux-x64.Cross.android-x86";
      version = runtimeVersion;
      kind = 0;
      hash = "sha256-WsNG1GytyhoFQ1xItm9GPb6TOBBeQyLSdcl7ujUswhI=";
    }
    {
      logicalId = "Microsoft.NETCore.App.Runtime.AOT.Cross.net10.android-x64";
      resolvedId = "Microsoft.NETCore.App.Runtime.AOT.linux-x64.Cross.android-x64";
      version = runtimeVersion;
      kind = 0;
      hash = "sha256-HrhgQsBakBu/7Pwnuxr+jaE63ITMFoCxYiM1avjAxRw=";
    }
  ];

  packs = map (
    spec:
    spec
    // {
      src = fetchNupkg {
        pname = spec.resolvedId;
        inherit (spec)
          version
          hash
          ;
      };
    }
  ) packSpecs;
in
stdenvNoCC.mkDerivation {
  pname = "dotnet-android-workload";
  version = "${workloadSetVersion}-${androidManifestVersion}";

  dontUnpack = true;
  dontAutoPatchelf = true;

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase =
    ''
      runHook preInstall

      mkdir -p "$out/share/dotnet/packs"
      mkdir -p "$out/share/dotnet/sdk-manifests/${featureBand}/microsoft.net.sdk.android/${androidManifestVersion}"
      cp ${androidManifest} "$out/share/dotnet/sdk-manifests/${featureBand}/microsoft.net.sdk.android/${androidManifestVersion}/WorkloadManifest.json"
      cp ${androidManifestTargets} "$out/share/dotnet/sdk-manifests/${featureBand}/microsoft.net.sdk.android/${androidManifestVersion}/WorkloadManifest.targets"
      cp ${androidWorkloadDependencies} "$out/share/dotnet/sdk-manifests/${featureBand}/microsoft.net.sdk.android/${androidManifestVersion}/WorkloadDependencies.json"
      mkdir -p "$out/share/dotnet/sdk-manifests/${featureBand}/workloadsets/${workloadSetVersion}"
      cp ${workloadSet} "$out/share/dotnet/sdk-manifests/${featureBand}/workloadsets/${workloadSetVersion}/microsoft.net.workloads.workloadset.json"

      mkdir -p "$out/share/dotnet/metadata/workloads/${featureBand}/InstalledWorkloads"
      : > "$out/share/dotnet/metadata/workloads/${featureBand}/InstalledWorkloads/android"
      mkdir -p "$out/share/dotnet/metadata/workloads/X64/${featureBand}/InstallState"
      cp ${installState} "$out/share/dotnet/metadata/workloads/X64/${featureBand}/InstallState/default.json"

      mkdir -p "$out/share/dotnet/metadata/workloads/InstalledManifests/v1/microsoft.net.sdk.android/${androidManifestVersion}/${featureBand}"
      : > "$out/share/dotnet/metadata/workloads/InstalledManifests/v1/microsoft.net.sdk.android/${androidManifestVersion}/${featureBand}/${featureBand}"

      mkdir -p "$out/share/dotnet/metadata/workloads/InstalledManifests/v1/microsoft.net.workload.mono.toolchain.current/${workloadSetVersion}/${featureBand}"
      : > "$out/share/dotnet/metadata/workloads/InstalledManifests/v1/microsoft.net.workload.mono.toolchain.current/${workloadSetVersion}/${featureBand}/${featureBand}"

      mkdir -p "$out/share/dotnet/metadata/workloads/InstalledWorkloadSets/v1/${workloadSetVersion}/${featureBand}"
      : > "$out/share/dotnet/metadata/workloads/InstalledWorkloadSets/v1/${workloadSetVersion}/${featureBand}/${featureBand}"
    ''
    + lib.concatMapStrings (
      spec: ''
        packDir="$out/share/dotnet/packs/${spec.resolvedId}/${spec.version}"
        mkdir -p "$packDir"
        unzip -qq ${spec.src} -d "$packDir"
        rm -f "$packDir/.signature.p7s"
        if [ -d "$packDir/tools" ]; then
          find "$packDir/tools" -type f -exec chmod +x {} +
        fi

        mkdir -p "$out/share/dotnet/metadata/workloads/InstalledPacks/v1/${spec.resolvedId}/${spec.version}"
        cat > "$out/share/dotnet/metadata/workloads/InstalledPacks/v1/${spec.resolvedId}/${spec.version}/${featureBand}" <<EOF
{"Id":"${spec.logicalId}","Version":"${spec.version}","Kind":${toString spec.kind},"ResolvedPackageId":"${spec.resolvedId}","Path":"$packDir","IsStillPacked":true}
EOF
      ''
    ) packs
    + ''
      runHook postInstall
    '';

  postFixup = ''
    addAutoPatchelfSearchPath "$out/share/dotnet/packs/Microsoft.Android.Sdk.Linux/${androidManifestVersion}/tools/Linux/binutils/lib"
    autoPatchelf -- \
      "$out/share/dotnet/packs/Microsoft.Android.Sdk.Linux/${androidManifestVersion}/tools/Linux" \
      "$out/share/dotnet/packs/Microsoft.Android.Sdk.Linux/${androidManifestVersion}/tools/libMono.Unix.so" \
      "$out/share/dotnet/packs/Microsoft.Android.Sdk.Linux/${androidManifestVersion}/tools/libZipSharpNative-3-3.so"

    for dir in "$out"/share/dotnet/packs/Microsoft.NETCore.App.Runtime.AOT.linux-x64.Cross.android-*/${runtimeVersion}/tools; do
      addAutoPatchelfSearchPath "$dir"
      autoPatchelf -- "$dir"
    done
  '';

  meta = {
    description = ".NET SDK 10 Android workload packs for NixOS";
    homepage = "https://github.com/dotnet/android";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lostmsu ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };
}
