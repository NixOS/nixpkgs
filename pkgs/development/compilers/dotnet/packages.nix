{
  stdenvNoCC,
  lib,
  callPackage,
  vmr,
  xmlstarlet,
  strip-nondeterminism,
  zip,
  nugetPackageHook,
  baseName ? "dotnet",
  fallbackTargetPackages ? { },
}:

let
  mkWrapper = callPackage ./wrapper.nix { };
  mkCommon =
    type: args:
    mkWrapper type (
      stdenvNoCC.mkDerivation (
        args
        // {
          outputs = args.outputs or [ "out" ] ++ [ "man" ];
          postFixup =
            args.postFixup or ""
            + ''
              ln -s ${vmr.man} $man
            '';
        }
      )
    );
  inherit (vmr) targetRid releaseManifest;

  # TODO: do this properly
  hostRid = targetRid;

  mkPackage =
    pname: version:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = vmr;
      dontUnpack = true;

      nativeBuildInputs = [
        xmlstarlet
        nugetPackageHook
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p "$out"

        pushd "$src"/Private.SourceBuilt.Artifacts.*.${targetRid}
        pushd ${pname}.${version}.nupkg

        xmlstarlet \
          sel -t \
          -m /_:package/_:metadata \
          -v _:id -nl \
          -v _:version -nl \
          *.nuspec | (
          read id
          read version
          id=''${id,,}
          version=''${version,,}
          mkdir -p "$out"/share/nuget/packages/"$id"
          cp -r . "$out"/share/nuget/packages/"$id"/"$version"
          chmod +w "$out"/share/nuget/packages/"$id"/"$version"
          echo {} > "$out"/share/nuget/packages/"$id"/"$version"/.nupkg.metadata
        )

        popd
        popd

        runHook postInstall
      '';
    };

  packages =
    [
      (mkPackage "Microsoft.AspNetCore.App.Ref" aspnetcore.version)
      (mkPackage "Microsoft.NETCore.DotNetAppHost" runtime.version)
      (mkPackage "Microsoft.NETCore.App.Ref" runtime.version)
      (mkPackage "Microsoft.DotNet.ILCompiler" runtime.version)
      (mkPackage "Microsoft.NET.ILLink.Tasks" runtime.version)
      (mkPackage "Microsoft.NETCore.App.Crossgen2.${hostRid}" runtime.version)
      (mkPackage "runtime.${hostRid}.Microsoft.DotNet.ILCompiler" runtime.version)
    ]
    ++ lib.optionals (lib.versionOlder runtime.version "9") [
      (mkPackage "Microsoft.NETCore.DotNetHost" runtime.version)
      (mkPackage "Microsoft.NETCore.DotNetHostPolicy" runtime.version)
      (mkPackage "Microsoft.NETCore.DotNetHostResolver" runtime.version)
    ]
    ++ targetPackages.${targetRid};

  targetPackages = fallbackTargetPackages // {
    ${targetRid} =
      [
        (mkPackage "Microsoft.AspNetCore.App.Runtime.${targetRid}" aspnetcore.version)
        (mkPackage "Microsoft.NETCore.App.Host.${targetRid}" runtime.version)
        (mkPackage "Microsoft.NETCore.App.Runtime.${targetRid}" runtime.version)
        (mkPackage "runtime.${targetRid}.Microsoft.NETCore.DotNetAppHost" runtime.version)
      ]
      ++ lib.optionals (lib.versionOlder runtime.version "9") [
        (mkPackage "runtime.${targetRid}.Microsoft.NETCore.DotNetHost" runtime.version)
        (mkPackage "runtime.${targetRid}.Microsoft.NETCore.DotNetHostPolicy" runtime.version)
        (mkPackage "runtime.${targetRid}.Microsoft.NETCore.DotNetHostResolver" runtime.version)
      ];
  };

  sdk = mkCommon "sdk" rec {
    pname = "${baseName}-sdk";
    version = releaseManifest.sdkVersion;

    src = vmr;
    dontUnpack = true;

    nativeBuildInputs = [
      xmlstarlet
      strip-nondeterminism
      zip
    ];

    outputs = [
      "out"
      "artifacts"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/share
      cp -r "$src"/dotnet-sdk-${version}-${targetRid} "$out"/share/dotnet
      chmod +w "$out"/share/dotnet
      mkdir "$out"/bin
      ln -s "$out"/share/dotnet/dotnet "$out"/bin/dotnet

      mkdir -p "$artifacts"
      cp -r "$src"/Private.SourceBuilt.Artifacts.*.${targetRid}/* "$artifacts"/
      chmod +w -R "$artifacts"

      local package

      for package in "$artifacts"/{,SourceBuildReferencePackages/}*.nupkg; do
        echo packing "$package" to artifacts
        (cd "$package" && zip -rq0 "$package.tmp" .)
        strip-nondeterminism --type zip "$package.tmp"
        rm -r "$package"
        mv "$package.tmp" "$package"
      done

      runHook postInstall
    '';

    passthru = {
      inherit (vmr) icu targetRid hasILCompiler;

      inherit
        packages
        targetPackages
        runtime
        aspnetcore
        ;
    };

    meta = vmr.meta // {
      mainProgram = "dotnet";
    };
  };

  runtime = mkCommon "runtime" rec {
    pname = "${baseName}-runtime";
    version = releaseManifest.runtimeVersion;

    src = vmr;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/share
      cp -r "$src/dotnet-runtime-${version}-${targetRid}" "$out"/share/dotnet
      chmod +w "$out"/share/dotnet
      mkdir "$out"/bin
      ln -s "$out"/share/dotnet/dotnet "$out"/bin/dotnet

      runHook postInstall
    '';

    meta = vmr.meta // {
      mainProgram = "dotnet";
    };
  };

  aspnetcore = mkCommon "aspnetcore" rec {
    pname = "${baseName}-aspnetcore-runtime";
    version = releaseManifest.aspNetCoreVersion or releaseManifest.runtimeVersion;

    src = vmr;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/share
      cp -r "$src/dotnet-runtime-${runtime.version}-${targetRid}" "$out"/share/dotnet
      chmod +w "$out"/share/dotnet/shared
      mkdir "$out"/bin
      ln -s "$out"/share/dotnet/dotnet "$out"/bin/dotnet

      cp -Tr "$src/aspnetcore-runtime-${version}-${targetRid}" "$out"/share/dotnet
      chmod +w "$out"/share/dotnet/shared

      runHook postInstall
    '';

    meta = vmr.meta // {
      mainProgram = "dotnet";
    };
  };
in
{
  inherit
    vmr
    sdk
    runtime
    aspnetcore
    ;

}
