{ version
, sha256
, nugetDeps
, dotnet-sdk
, libraryFramework
, testFramework
, lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, xmlstarlet
, runCommand
, xxd
}: let

  # We use the Newtonsoft public key to sign the libraries, since they don't
  # provide a key in the repo.
  # This is consistent with what's done in source sdk builds:
  # https://github.com/dotnet/installer/tree/main/src/SourceBuild/tarball/content/keys
  # https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/security#publicsign
  # The build tools require the key to be binary.
  key = runCommand "newtonsoft-public-key" {} ''
    ${xxd}/bin/xxd -r -p ${./key.pub} > $out
  '';

  finalPackage = buildDotnetModule rec {
    pname = "newtonsoft-json";
    inherit version;

    src = fetchFromGitHub {
      owner = "JamesNK";
      repo = "Newtonsoft.Json";
      rev = "refs/tags/${version}";
      inherit sha256;
    };

    nativeBuildInputs = [ dotnet-sdk xmlstarlet ];

    postPatch = ''
      # disable unused frameworks in test console
      xml ed --inplace \
        -u Project/PropertyGroup/TargetFrameworks \
        -v "${testFramework}" \
        Src/Newtonsoft.Json.TestConsole/Newtonsoft.Json.TestConsole.csproj
      # disable packing of unpublished projects
      xml ed --inplace \
        -a "Project/PropertyGroup/IsPackable[text()='false']" \
        -t elem -n IsPublishable -v false \
        Src/Newtonsoft.Json.Tests/Newtonsoft.Json.Tests.csproj \
        Src/Newtonsoft.Json.TestConsole/Newtonsoft.Json.TestConsole.csproj
    '';

    projectFile = "Src/Newtonsoft.Json.sln";
    # doCheck = true;

    inherit nugetDeps;

    # not supported with netcoreapp2.0
    # remove once we're >= netcoreapp2.1
    useAppHost = false;

    dotnetFlags = [
      "-p:LibraryFrameworks=${libraryFramework}"
      "-p:TestFrameworks=${testFramework}"
      "-p:VersionPrefix=${version}"
      "-p:VersionSuffix="
      "-p:AssemblyVersion=${lib.versions.majorMinor version}.0.0"
      "-p:FileVersion=${version}"
      "-p:AssemblyOriginatorKeyFile=${key}"
      "-p:SignAssembly=true"
      "-p:PublicSign=true"
      "-p:AdditionalConstants=SIGNED"
    ];

    dotnetInstallFlags = [
      "--framework" libraryFramework
    ];

    # TODO: investigate why these fail
    disabledTests = [
      "Newtonsoft.Json.Tests.Issues.Issue1619.Test"
      "Newtonsoft.Json.Tests.Documentation.TraceWriterTests.MemoryTraceWriterTest"
      "Newtonsoft.Json.Tests.Serialization.TraceWriterTests.MemoryTraceWriterDeserializeTest"
      "Newtonsoft.Json.Tests.Serialization.TraceWriterTests.MemoryTraceWriterSerializeTest"
      "Newtonsoft.Json.Tests.JsonTextWriterTest.BufferErroringWithInvalidSize"
    ];

    packNupkg = true;
  };

in finalPackage
