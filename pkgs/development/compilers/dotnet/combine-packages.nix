packages:
{ buildEnv, makeWrapper, lib }:
# TODO: Rethink how we determine and/or get the CLI.
#       Possible options raised in #187118:
#         1. A separate argument for the CLI (as suggested by IvarWithoutBones
#         2. Use the highest version SDK for the CLI (as suggested by GGG)
#         3. Something else?
let cli = builtins.head packages;
in
assert lib.assertMsg ((builtins.length packages) < 1)
    ''You must include at least one package, e.g
      `with dotnetCorePackages; combinePackages [
          sdk_3_1 aspnetcore_5_0
       ];`'' ;
  buildEnv {
    name = "dotnet-core-combined";
    paths = packages;
    pathsToLink = [ "/host" "/packs" "/sdk" "/sdk-manifests" "/shared" "/templates" ];
    ignoreCollisions = true;
    nativeBuildInputs = [
      makeWrapper
    ];
    postBuild = ''
      cp -R ${cli}/{dotnet,LICENSE.txt,nix-support,ThirdPartyNotices.txt} $out/

      mkdir $out/bin
      ln -s $out/dotnet $out/bin/dotnet
      wrapProgram $out/bin/dotnet \
        --prefix LD_LIBRARY_PATH : ${cli.icu}/lib
    '';
    passthru = {
      inherit (cli) icu packages;
    };
  }
