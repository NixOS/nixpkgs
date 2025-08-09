{
  lib,
  stdenv,
  yarn-berry-fetcher,
  nix-prefetch-git,
  cacert,
  berryVersion,
}:

{
  src ? null,
  hash ? "",
  sha256 ? "",
  ...
}@args:

let
  hash_ =
    if hash != "" then
      {
        outputHashAlgo = null;
        outputHash = hash;
      }
    else if sha256 != "" then
      {
        outputHashAlgo = "sha256";
        outputHash = sha256;
      }
    else
      {
        outputHashAlgo = "sha256";
        outputHash = lib.fakeSha256;
      };
in

stdenv.mkDerivation (
  {
    # The name is fixed as to not produce multiple store paths with the same content
    name = "offline";

    dontUnpack = src == null;
    dontInstall = true;

    nativeBuildInputs = [
      yarn-berry-fetcher
      nix-prefetch-git
      cacert
    ];

    buildPhase = ''
      runHook preBuild

      yarnLock=''${yarnLock:=$PWD/yarn.lock}
      yarn-berry-fetcher fetch $yarnLock $missingHashes

      runHook postBuild
    '';

    outputHashMode = "recursive";

    dontFixup = true; # fixup phase does the patching of the shebangs, and FODs must never contain nix store paths.

    passthru = {
      inherit berryVersion;
    };
  }
  // hash_
  // (removeAttrs args (
    [
      "name"
      "pname"
      "version"
      "hash"
      "sha256"
    ]
    ++ (lib.optional (src == null) "src")
  ))
)
