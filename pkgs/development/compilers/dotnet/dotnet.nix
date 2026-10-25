{
  config,
  callPackage,
  lib,
  channel,
  dir ? ./. + ("/" + channel),
  buildDotnetSdk,
  ...
}@attrs:

let
  binary =
    let
      path = dir + "/releases.nix";
    in
    if lib.pathExists path then buildDotnetSdk path else { };

  withVMR = lib.pathExists (dir + "/release.json");

  sourcePackages = lib.optionalAttrs withVMR (callPackage ./source (attrs // { inherit binary; }));

  pkgs =
    lib.optionalAttrs config.allowAliases binary
    // lib.mapAttrs' (k: v: lib.nameValuePair "${k}-bin" v) binary
    // sourcePackages;

  suffix = lib.replaceStrings [ "." ] [ "_" ] channel;
  sdkAttr = "sdk_${suffix}" + lib.optionalString (!withVMR) "-bin";
in
pkgs
// {
  ${sdkAttr} = pkgs.${sdkAttr}.overrideAttrs (prev: {
    passthru = prev.passthru or { } // {
      updateScript = [
        ./update.sh
        channel
      ];
    };
  });
}
