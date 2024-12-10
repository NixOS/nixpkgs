{ cacert, dhall, dhall-docs, haskell, lib, runCommand }:

# `buildDhallUrl` is similar to `buildDhallDirectoryPackage` or
# `buildDhallGitHubPackage`, but instead builds a Nixpkgs Dhall package
# based on a hashed URL.  This will generally be a URL that has an integrity
# check in a Dhall file.
#
# Similar to `buildDhallDirectoryPackage` and `buildDhallGitHubPackage`, the output
# of this function is a derivation that has a `binary.dhall` file, along with
# a `.cache/` directory with the actual contents of the Dhall file from the
# suppiled URL.
#
# This function is primarily used by `dhall-to-nixpkgs directory --fixed-output-derivations`.

{ # URL of the input Dhall file.
  # example: "https://raw.githubusercontent.com/cdepillabout/example-dhall-repo/c1b0d0327146648dcf8de997b2aa32758f2ed735/example1.dhall"
  url

  # Nix hash of the input Dhall file.
  # example: "sha256-ZTSiQUXpPbPfPvS8OeK6dDQE6j6NbP27ho1cg9YfENI="
, hash

  # Dhall hash of the input Dhall file.
  # example: "sha256:6534a24145e93db3df3ef4bc39e2ba743404ea3e8d6cfdbb868d5c83d61f10d2"
, dhallHash

  # Name for this derivation.
, name ? (baseNameOf url + "-cache")

  # `buildDhallUrl` can include both a "source distribution" in
  # `source.dhall` and a "binary distribution" in `binary.dhall`:
  #
  # * `source.dhall` is a dependency-free αβ-normalized Dhall expression
  #
  # * `binary.dhall` is an expression of the form: `missing sha256:${HASH}`
  #
  #   This expression requires you to install the cache product located at
  #   `.cache/dhall/1220${HASH}` to successfully resolve
  #
  # By default, `buildDhallUrl` only includes "binary.dhall" to conserve
  # space within the Nix store, but if you set the following `source` option to
  # `true` then the package will also include `source.dhall`.
, source ? false
}:

let
  # HTTP support is disabled in order to force that HTTP dependencies are built
  # using Nix instead of using Dhall's support for HTTP imports.
  dhallNoHTTP = haskell.lib.appendConfigureFlag dhall "-f-with-http";

  # This uses Dhall's remote importing capabilities for downloading a Dhall file.
  # The output Dhall file has all imports resolved, and then is
  # alpha-normalized and binary-encoded.
  downloadedEncodedFile =
    runCommand
      (baseNameOf url)
      {
        outputHashAlgo = null;
        outputHash = hash;
        name = baseNameOf url;
        nativeBuildInputs = [ cacert ];
        impureEnvVars = lib.fetchers.proxyImpureEnvVars;
      }
      ''
        echo "${url} ${dhallHash}" > in-dhall-file
        ${dhall}/bin/dhall --alpha --plain --file in-dhall-file | ${dhallNoHTTP}/bin/dhall encode > $out
      '';

   cache = ".cache";

   data = ".local/share";

   cacheDhall = "${cache}/dhall";

   dataDhall = "${data}/dhall";

   sourceFile = "source.dhall";

in
  runCommand name { }
 (''
    set -eu

    mkdir -p ${cacheDhall} $out/${cacheDhall}

    export XDG_CACHE_HOME=$PWD/${cache}

    SHA_HASH="${dhallHash}"

    HASH_FILE="''${SHA_HASH/sha256:/1220}"

    cp ${downloadedEncodedFile} $out/${cacheDhall}/$HASH_FILE

    echo "missing $SHA_HASH" > $out/binary.dhall
  '' +
  lib.optionalString source ''
    ${dhallNoHTTP}/bin/dhall decode --file ${downloadedEncodedFile} > $out/${sourceFile}
  '')
