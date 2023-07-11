dotnetPackages:
{ buildEnv, makeWrapper, lib }:
# TODO: Rethink how we determine and/or get the CLI.
#       Possible options raised in #187118:
#         1. A separate argument for the CLI (as suggested by IvarWithoutBones
#         2. Use the highest version SDK for the CLI (as suggested by GGG)
#         3. Something else?
let cli = builtins.head dotnetPackages;
in
assert lib.assertMsg ((builtins.length dotnetPackages) > 0)
    ''You must include at least one package, e.g
      `with dotnetCorePackages; combinePackages [
          sdk_6_0 aspnetcore_7_0
       ];`'' ;
  buildEnv {
    name = "dotnet-core-combined";
    paths = dotnetPackages;
    pathsToLink = [ "/host" "/packs" "/sdk" "/sdk-manifests" "/shared" "/templates" ];
    ignoreCollisions = true;
    nativeBuildInputs = [
      makeWrapper
    ];
    postBuild = ''
      cp -R ${cli}/{dotnet,share,nix-support} $out/

      mkdir $out/bin
      ln -s $out/dotnet $out/bin/dotnet
      wrapProgram $out/bin/dotnet \
        --prefix LD_LIBRARY_PATH : ${cli.icu}/lib
    '';
    passthru = {
      inherit (cli) icu;

      versions = lib.catAttrs "version" dotnetPackages;
      packages = lib.remove null (lib.catAttrs "packages" dotnetPackages);
    };

    inherit (cli) meta;
  }
