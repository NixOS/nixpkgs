{ stdenv
, callPackage
, vmr
, xmlstarlet
, strip-nondeterminism
, zip
}:

let
  mkCommon = callPackage ./common.nix {};
  inherit (vmr) targetRid releaseManifest;

in {
  inherit vmr;
  sdk = mkCommon "sdk" rec {
    pname = "dotnet-sdk";
    version = releaseManifest.sdkVersion;

    src = vmr;
    dontUnpack = true;

    nativeBuildInputs = [
      xmlstarlet
      strip-nondeterminism
      zip
    ];

    outputs = [ "out" "packages" "artifacts" ];

    installPhase = ''
      runHook preInstall

      cp -r "$src"/dotnet-sdk-${version}-${targetRid} "$out"
      chmod +w "$out"
      mkdir "$out"/bin
      ln -s "$out"/dotnet "$out"/bin/dotnet

      mkdir -p "$packages" "$artifacts"
      cp -r "$src"/Private.SourceBuilt.Artifacts.*.${targetRid}/* "$artifacts"/
      chmod +w -R "$artifacts"

      local package

      for package in "$artifacts"/*.nupkg; do
        local copy
        case "$(basename "$package")" in
          *Microsoft.NET.* | \
          *Microsoft.ILLink.* | \
          *Microsoft.Tasks.* | \
          *Microsoft.NETCore.* | \
          *Microsoft.DotNet.* | \
          *Microsoft.AspNetCore.*) copy=1 ;;
          *) copy= ;;
        esac
        if [[ -n $copy ]]; then
          echo copying "$package" to packages
          xmlstarlet \
            sel -t \
            -m /_:package/_:metadata \
            -v _:id -nl \
            -v _:version -nl \
            "$package"/*.nuspec | (
            read id
            read version
            id=''${id,,}
            version=''${version,,}
            mkdir -p "$packages"/share/nuget/packages/"$id"
            cp -r "$package" "$packages"/share/nuget/packages/"$id"/"$version"
            echo {} > "$packages"/share/nuget/packages/"$id"/"$version"/.nupkg.metadata
          )
        fi
      done

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
    };

    meta = vmr.meta // {
      mainProgram = "dotnet";
    };
  };

  runtime = mkCommon "runtime" rec {
    pname = "dotnet-runtime";
    version = releaseManifest.runtimeVersion;

    src = vmr;
    dontUnpack = true;

    outputs = [ "out" ];

    installPhase = ''
      runHook preInstall

      cp -r "$src/dotnet-runtime-${version}-${targetRid}" "$out"
      chmod +w "$out"
      mkdir "$out"/bin
      ln -s "$out"/dotnet "$out"/bin/dotnet

      runHook postInstall
    '';

    meta = vmr.meta // {
      mainProgram = "dotnet";
    };
  };

  aspnetcore = mkCommon "aspnetcore" rec {
    pname = "dotnet-aspnetcore-runtime";
    version = releaseManifest.aspNetCoreVersion or releaseManifest.runtimeVersion;

    src = vmr;
    dontUnpack = true;

    outputs = [ "out" ];

    installPhase = ''
      runHook preInstall

      cp -r "$src/dotnet-runtime-${releaseManifest.runtimeVersion}-${targetRid}" "$out"
      chmod +w "$out"
      mkdir "$out"/bin
      ln -s "$out"/dotnet "$out"/bin/dotnet

      chmod +w "$out"/shared
      cp -Tr "$src/aspnetcore-runtime-${version}-${targetRid}" "$out"

      runHook postInstall
    '';

    meta = vmr.meta // {
      mainProgram = "dotnet";
    };
  };
}
