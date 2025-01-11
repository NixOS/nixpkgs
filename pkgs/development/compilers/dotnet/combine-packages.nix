dotnetPackages:
{
  buildEnv,
  makeWrapper,
  lib,
  symlinkJoin,
  callPackage,
}:
# TODO: Rethink how we determine and/or get the CLI.
#       Possible options raised in #187118:
#         1. A separate argument for the CLI (as suggested by IvarWithoutBones
#         2. Use the highest version SDK for the CLI (as suggested by GGG)
#         3. Something else?
let
  cli = builtins.head dotnetPackages;
  mkWrapper = callPackage ./wrapper.nix { };
in
assert lib.assertMsg ((builtins.length dotnetPackages) > 0) ''
  You must include at least one package, e.g
        `with dotnetCorePackages; combinePackages [
            sdk_6_0 aspnetcore_7_0
         ];`'';
mkWrapper "sdk" (buildEnv {
  name = "dotnet-combined";
  paths = dotnetPackages;
  pathsToLink = map (x: "/share/dotnet/${x}") [
    "host"
    "packs"
    "sdk"
    "sdk-manifests"
    "shared"
    "templates"
  ];
  ignoreCollisions = true;
  nativeBuildInputs = [ makeWrapper ];
  postBuild =
    ''
      mkdir -p "$out"/share/dotnet
      cp "${cli}"/share/dotnet/dotnet $out/share/dotnet
      cp -R "${cli}"/nix-support "$out"/
      mkdir "$out"/bin
      ln -s "$out"/share/dotnet/dotnet "$out"/bin/dotnet
    ''
    + lib.optionalString (cli ? man) ''
      ln -s ${cli.man} $man
    '';
  passthru = {
    pname = "dotnet";
    version = "combined";
    inherit (cli) icu;

    versions = lib.catAttrs "version" dotnetPackages;
    packages = lib.concatLists (lib.catAttrs "packages" dotnetPackages);
    targetPackages = lib.zipAttrsWith (_: lib.concatLists) (
      lib.catAttrs "targetPackages" dotnetPackages
    );
  };

  meta = {
    description = "${cli.meta.description or "dotnet"} (combined)";
    inherit (cli.meta)
      homepage
      license
      mainProgram
      maintainers
      platforms
      ;
  };
})
