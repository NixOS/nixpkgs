{ go, govers, lib }:

{ name, buildInputs ? [], nativeBuildInputs ? [], passthru ? {}

# Disabled flag
, disabled ? false

# Go import path of the package
, goPackagePath

# Go package aliases
, goPackageAliases ? [ ]

# Extra sources to include in the gopath
, extraSrcs ? [ ]

, dontRenameImports ? false

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, meta ? {}, ... } @ args':

if disabled then throw "${name} not supported for go ${go.meta.branch}" else

let
  args = lib.filterAttrs (name: _: name != "extraSrcs") args';

  removeReferences = [ go ];

  removeExpr = refs: lib.flip lib.concatMapStrings refs (ref: ''
    | sed "s,${ref},$(echo "${ref}" | sed "s,$NIX_STORE/[^-]*,$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee,"),g" \
  '');
in

go.stdenv.mkDerivation (
  (builtins.removeAttrs args [ "goPackageAliases" "disabled" ]) // {

  name = "go${go.meta.branch}-${name}";
  nativeBuildInputs = [ go ]
    ++ (lib.optional (!dontRenameImports) govers) ++ nativeBuildInputs;
  buildInputs = [ go ] ++ buildInputs;

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
      inputsWithAliases = lib.filter (x: x ? goPackageAliases)
        (buildInputs ++ (args.propagatedBuildInputs or [ ]));
      rename = to: from: "echo Renaming '${from}' to '${to}'; govers -d -m ${from} ${to}";
      renames = p: lib.concatMapStringsSep "\n" (rename p.goPackagePath) p.goPackageAliases;
    in lib.concatMapStringsSep "\n" renames inputsWithAliases);

  buildPhase = args.buildPhase or ''
    runHook preBuild

    runHook renameImports

    PIDS=()
    if [ -n "$subPackages" ] ; then
        for p in $subPackages ; do
            go install $buildFlags "''${buildFlagsArray[@]}" -p $NIX_BUILD_CORES -v $goPackagePath/$p &
            PIDS+=("$!")
        done
    else
        pushd go/src
        while read d; do
          {
            echo "$d" | grep -q "/_" && continue
            [ -n "$excludedPackages" ] && echo "$d" | grep -q "$excludedPackages" && continue
            local OUT
            if ! OUT="$(go install $buildFlags "''${buildFlagsArray[@]}" -p $NIX_BUILD_CORES -v $d 2>&1)"; then
                if ! echo "$OUT" | grep -q 'no buildable Go source files'; then
                    echo "$OUT" >&2
                    exit 1
                fi
            fi
            if [ -n "$OUT" ]; then
              echo "$OUT" >&2
            fi
          } &
          PIDS+=("$!")
        done < <(find $goPackagePath -type f -name \*.go -exec dirname {} \; | sort | uniq)
        popd
    fi

    # Exit on error from the parallel process
    for PID in "''${PIDS[@]}"; do
        wait $PID || exit 1
    done

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck

    PIDS=()
    if [ -n "$subPackages" ] ; then
        for p in $subPackages ; do
            go test -p $NIX_BUILD_CORES -v $goPackagePath/$p &
        done
        PIDS+=("$!")
    else
        pushd go/src
        while read d; do
            go test -p $NIX_BUILD_CORES -v $d &
        done < <(find $goPackagePath -type f -name \*_test.go -exec dirname {} \; | sort | uniq)
        popd
        PIDS+=("$!")
    fi

    # Exit on error from the parallel process
    for PID in "''${PIDS[@]}"; do
        wait $PID || exit 1
    done

    runHook postCheck
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    mkdir -p $out

    if [ -z "$dontInstallSrc" ]; then
        pushd "$NIX_BUILD_TOP/go"
        while read f; do
          echo "$f" | grep -q '^./\(src\|pkg/[^/]*\)/${goPackagePath}' || continue
          mkdir -p "$(dirname "$out/share/go/$f")"
          cp "$NIX_BUILD_TOP/go/$f" "$out/share/go/$f"
        done < <(find . -type f)
        popd
    fi

    dir="$NIX_BUILD_TOP/go/bin"
    [ -e "$dir" ] && cp -r $dir $out
    while read file; do
      cat $file ${removeExpr removeReferences} > $file.tmp
      mv $file.tmp $file
      chmod +x $file
    done < <(find $out/bin -type f 2>/dev/null)

    runHook postInstall
  '';

  disallowedReferences = lib.optional (!allowGoReference) go
    ++ lib.optional (!dontRenameImports) govers;

  passthru = passthru // lib.optionalAttrs (goPackageAliases != []) { inherit goPackageAliases; };

  meta = {
    # Add default meta information
    platforms = lib.platforms.all;
  } // meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.emery lib.maintainers.lethalman ];
  };
})
