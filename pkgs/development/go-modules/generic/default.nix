{ go, govers, lib }:

{ name, buildInputs ? []

# Go import path of the package
, goPackagePath

# Go package aliases
, goPackageAliases ? [ ]

# Extra sources to include in the gopath
, extraSrcs ? [ ]

, dontRenameImports ? false

, meta ? {}, ... } @ args':

let
  args = lib.filterAttrs (name: _: name != "extraSrcs") args';
in

go.stdenv.mkDerivation (
  (builtins.removeAttrs args [ "goPackageAliases" ]) // {

  name = "go${go.meta.branch}-${name}";
  buildInputs = [ go ] ++ buildInputs ++ (lib.optional (!dontRenameImports) govers) ;

  configurePhase = args.configurePhase or ''
    runHook preConfigure

    # Extract the source
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/$(dirname "$goPackagePath")"
    mv "$sourceRoot" "go/src/$goPackagePath"

  '' + lib.flip lib.concatMapStrings extraSrcs ({ src, goPackagePath }: ''
    mkdir extraSrc
    (cd extraSrc; unpackFile "${src}")
    mkdir -p "go/src/$(dirname "${goPackagePath}")"
    chmod -R u+w extraSrc/*
    mv extraSrc/* "go/src/${goPackagePath}"
    rmdir extraSrc

  '') + ''
    GOPATH=$NIX_BUILD_TOP/go:$GOPATH

    runHook postConfigure
  '';

  renameImports = args.renameImports or (
    let
      inputsWithAliases = lib.filter (x: x ? goPackageAliases) buildInputs;
      rename = to: from: "echo Renaming '${from}' to '${to}'; govers -m ${from} ${to}";
      renames = p: lib.concatMapStringsSep "\n" (rename p.goPackagePath) p.goPackageAliases;
    in lib.concatMapStringsSep "\n" renames inputsWithAliases);

  buildPhase = args.buildPhase or ''
    runHook preBuild

    runHook renameImports

    if [ -n "$subPackages" ] ; then
        for p in $subPackages ; do
            go install $buildFlags "''${buildFlagsArray[@]}" -p $NIX_BUILD_CORES -v $goPackagePath/$p
        done
    else
        (cd go/src
        find $goPackagePath -type f -name \*.go -exec dirname {} \; | sort | uniq | while read d; do
            local OUT;
            if ! OUT="$(go install $buildFlags "''${buildFlagsArray[@]}" -p $NIX_BUILD_CORES -v $d 2>&1)"; then
                if ! echo "$OUT" | grep -q 'no buildable Go source files'; then
                    echo "$OUT" >&2
                    exit 1
                fi
            fi
        done)
    fi

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck

    if [ -n "$subPackages" ] ; then
        for p in $subPackages ; do
            go test -p $NIX_BUILD_CORES -v $goPackagePath/$p
        done
    else
        (cd go/src
        find $goPackagePath -type f -name \*_test.go -exec dirname {} \; | sort | uniq | while read d; do
            go test -p $NIX_BUILD_CORES -v $d
        done)
    fi

    runHook postCheck
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    mkdir $out

    if [ -z "$dontInstallSrc" ]; then
        local dir
        for d in pkg src; do
            mkdir -p $out/share/go
            dir="$NIX_BUILD_TOP/go/$d"
            [ -e "$dir" ] && cp -r $dir $out/share/go
        done
    fi

    dir="$NIX_BUILD_TOP/go/bin"
    [ -e "$dir" ] && cp -r $dir $out

    runHook postInstall
  '';

  passthru = lib.optionalAttrs (goPackageAliases != []) { inherit goPackageAliases; };

  meta = meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.emery lib.maintainers.lethalman ];
  };
})
