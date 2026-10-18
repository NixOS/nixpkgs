{ pkgs, channel }:

let
  prefix = "sdk_" + builtins.replaceStrings [ "." ] [ "_" ] channel;
  names = builtins.filter (name: builtins.match "${prefix}(_[0-9]+xx)?(-bin|-source)?" name != null) (
    builtins.attrNames pkgs.dotnetCorePackages
  );
in
map (
  name:
  let
    sdk = pkgs.dotnetCorePackages.${name};
    resolver = pkgs.callPackage ./. { inherit sdk; };
  in
  {
    inherit name;
    inherit (sdk) version;
    sdkDrv = sdk.unwrapped.drvPath;
    sdkRoot = "${sdk.unwrapped}/share/dotnet";
    resolverDrv = resolver.drvPath;
  }
) names
