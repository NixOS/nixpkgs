{ dhall, dhall-docs, haskell, lib, lndir, runCommand, writeText }:

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

  # Directory to generate documentation for (i.e. as the `--input` option to the
  # `dhall-docs` command.)
  #
  # If `null`, then no documentation is generated.
, documentationRoot ? null

  # Base URL prepended to paths copied to the clipboard
  #
  # This is used in conjunction with `documentationRoot`, and is unused if
  # `documentationRoot` is `null`.
, baseImportUrl ? null
}:

let
  # HTTP support is disabled in order to force that HTTP dependencies are built
  # using Nix instead of using Dhall's support for HTTP imports.
  dhallNoHTTP = haskell.lib.compose.appendConfigureFlag "-f-with-http" dhall;

  file = writeText "${name}.dhall" code;

  cache = ".cache";

  data = ".local/share";

  cacheDhall = "${cache}/dhall";

  dataDhall = "${data}/dhall";

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

    ${dhallNoHTTP}/bin/dhall --alpha --file '${file}' > $out/${sourceFile}

    SHA_HASH=$(${dhallNoHTTP}/bin/dhall hash <<< $out/${sourceFile})

    HASH_FILE="''${SHA_HASH/sha256:/1220}"

    ${dhallNoHTTP}/bin/dhall encode --file $out/${sourceFile} > $out/${cacheDhall}/$HASH_FILE

    echo "missing $SHA_HASH" > $out/binary.dhall

    ${lib.optionalString (!source) "rm $out/${sourceFile}"}

    ${lib.optionalString (documentationRoot != null) ''
    mkdir -p $out/${dataDhall}

    XDG_DATA_HOME=$out/${data} ${dhall-docs}/bin/dhall-docs --output-link $out/docs ${lib.cli.toGNUCommandLineShell { } {
      base-import-url = baseImportUrl;

      input = documentationRoot;

      package-name = name;
    }}
    ''}
  ''
