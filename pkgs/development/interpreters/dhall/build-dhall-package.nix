{ haskell, haskellPackages, lib, lndir, runCommand, writeText }:

{ name

  # Expressions to add to the cache before interpreting the code
, dependencies ? []

  # A Dhall expression
  #
  # Carefully note that the following expression must be devoid of uncached HTTP
  # imports.  This is because the expression will be evaluated using an
  # interpreter with HTTP support disabled, so all HTTP imports have to be
  # protected by an integrity check that can be satisfied via cached
  # dependencies.
  #
  # You can add a dependency to the cache using the preceding `dependencies`
  # option
, code

  # `buildDhallPackage` can include both a "source distribution" in
  # `source.dhall` and a "binary distribution" in `binary.dhall`:
  #
  # * `source.dhall` is a dependency-free αβ-normalized Dhall expression
  #
  # * `binary.dhall` is an expression of the form: `missing sha256:${HASH}`
  #
  #   This expression requires you to install the cache product located at
  #   `.cache/dhall/1220${HASH}` to successfully resolve
  #
  # By default, `buildDhallPackage` only includes "binary.dhall" to conserve
  # space within the Nix store, but if you set the following `source` option to
  # `true` then the package will also include `source.dhall`.
, source ? false
}:

let
  # `buildDhallPackage` requires version 1.25.0 or newer of the Haskell
  # interpreter for Dhall.  Given that the default version is 1.24.0 we choose
  # the latest available version instead until the default is upgraded.
  #
  # HTTP support is disabled in order to force that HTTP dependencies are built
  # using Nix instead of using Dhall's support for HTTP imports.
  dhall =
    haskell.lib.justStaticExecutables
      (haskell.lib.appendConfigureFlag
        haskellPackages.dhall_1_29_0
        "-f-with-http"
      );

  file = writeText "${name}.dhall" code;

  cache = ".cache";

  cacheDhall = "${cache}/dhall";

  sourceFile = "source.dhall";

in
  runCommand name { inherit dependencies; } ''
    set -eu

    mkdir -p ${cacheDhall}

    for dependency in $dependencies; do
      ${lndir}/bin/lndir -silent $dependency/${cacheDhall} ${cacheDhall}
    done

    export XDG_CACHE_HOME=$PWD/${cache}

    mkdir -p $out/${cacheDhall}

    ${dhall}/bin/dhall --alpha --file '${file}' > $out/${sourceFile}

    SHA_HASH=$(${dhall}/bin/dhall hash <<< $out/${sourceFile})

    HASH_FILE="''${SHA_HASH/sha256:/1220}"

    ${dhall}/bin/dhall encode --file $out/${sourceFile} > $out/${cacheDhall}/$HASH_FILE

    echo "missing $SHA_HASH" > $out/binary.dhall

    ${lib.optionalString (!source) "rm $out/${sourceFile}"}
  ''
