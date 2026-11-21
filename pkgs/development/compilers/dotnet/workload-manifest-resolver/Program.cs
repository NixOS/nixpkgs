using System;
using System.Collections;
using System.Linq;
using System.Text.Json;
using Microsoft.NET.Sdk.WorkloadManifestReader;

if (args.Length != 2)
{
    Console.Error.WriteLine("Usage: dotnet-workload-manifest-resolver SDK_ROOT SDK_VERSION");
    return 1;
}

foreach (DictionaryEntry variable in Environment.GetEnvironmentVariables())
{
    if (((string)variable.Key).StartsWith("DOTNETSDK_WORKLOAD_", StringComparison.Ordinal))
    {
        Environment.SetEnvironmentVariable((string)variable.Key, null);
    }
}

var provider = new SdkDirectoryWorkloadManifestProvider(
    args[0], args[1], userProfileDir: null, globalJsonPath: null);
Console.WriteLine(JsonSerializer.Serialize(new
{
    sdkVersion = args[1],
    sdkFeatureBand = provider.GetSdkFeatureBand(),
    manifests = provider.GetManifests().Select(manifest => new
    {
        id = manifest.ManifestId,
        path = manifest.ManifestPath,
        featureBand = manifest.ManifestFeatureBand,
        version = manifest.ManifestVersion,
    }),
}));
return 0;
