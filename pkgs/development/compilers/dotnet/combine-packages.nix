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
            sdk_9_0 aspnetcore_8_0
         ];`'';
mkWrapper "sdk" (
  (buildEnv {
    name = "dotnet-combined";
    paths = dotnetPackages;
    pathsToLink = map (x: "/share/dotnet/${x}") [
      "host"
      "metadata"
      "packs"
      "sdk"
      "sdk-manifests"
      "shared"
      "templates"
    ];
    ignoreCollisions = true;
    nativeBuildInputs = [ makeWrapper ];
    postBuild = ''
      mkdir -p "$out"/bin "$out"/share/dotnet
      cp -R "${cli}"/nix-support "$out"/
      cp "${cli}"/share/dotnet/dotnet "$out"/share/dotnet
      # dotnet won't run if it's renamed, so we can't wrap it in-place
      makeWrapper "$out"/share/dotnet/dotnet "$out"/share/dotnet/.dotnet-wrapper \
        --set-default DOTNET_HOST_PATH "$out"/share/dotnet/dotnet
      # the wrapper itself can't be in $out/bin, because things follow symlinks
      # to find DOTNET_ROOT
      ln -s "$out"/share/dotnet/.dotnet-wrapper "$out"/bin/dotnet
      if [[ -e "${cli}"/share/dotnet/dnx ]]; then
        cp "${cli}"/share/dotnet/dnx "$out"/share/dotnet
        makeWrapper "$out"/share/dotnet/dnx "$out"/share/dotnet/.dnx-wrapper \
          --set-default DOTNET_HOST_PATH "$out"/share/dotnet/dotnet
        ln -s "$out"/share/dotnet/.dnx-wrapper "$out"/bin/dnx
      fi
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
  }).overrideAttrs
    {
      propagatedSandboxProfile = toString (
        lib.unique (lib.concatLists (lib.catAttrs "__propagatedSandboxProfile" dotnetPackages))
      );
    }
)
