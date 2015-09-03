{ go, govers, parallel, lib }:

{ name, buildInputs ? [], nativeBuildInputs ? [], passthru ? {}, preFixup ? ""

# We want parallel builds by default
, enableParallelBuilding ? true

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
  nativeBuildInputs = [ go parallel ]
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
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH

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

    buildGoDir() {
      local d; local cmd;
      cmd="$1"
      d="$2"
      echo "$d" | grep -q "\(/_\|examples\|Godeps\)" && return 0
      [ -n "$excludedPackages" ] && echo "$d" | grep -q "$excludedPackages" && return 0
      local OUT
      if ! OUT="$(go $cmd $buildFlags "''${buildFlagsArray[@]}" -v $d 2>&1)"; then
        if ! echo "$OUT" | grep -q 'no buildable Go source files'; then
          echo "$OUT" >&2
          return 1
        fi
      fi
      if [ -n "$OUT" ]; then
        echo "$OUT" >&2
      fi
      return 0
    }

    getGoDirs() {
      local type;
      type="$1"
      if [ -n "$subPackages" ]; then
        echo "$subPackages" | sed "s,\(^\| \),\1$goPackagePath/,g"
      else
        pushd go/src >/dev/null
        find "$goPackagePath" -type f -name \*$type.go -exec dirname {} \; | sort | uniq
        popd >/dev/null
      fi
    }

    export -f buildGoDir # parallel needs to see the function
    getGoDirs "" | parallel -j $NIX_BUILD_CORES buildGoDir install

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck

    getGoDirs test | parallel -j $NIX_BUILD_CORES buildGoDir test

    runHook postCheck
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    mkdir -p $out
    pushd "$NIX_BUILD_TOP/go"
    while read f; do
      echo "$f" | grep -q '^./\(src\|pkg/[^/]*\)/${goPackagePath}' || continue
      mkdir -p "$(dirname "$out/share/go/$f")"
      cp "$NIX_BUILD_TOP/go/$f" "$out/share/go/$f"
    done < <(find . -type f)
    popd

    mkdir -p $bin
    dir="$NIX_BUILD_TOP/go/bin"
    [ -e "$dir" ] && cp -r $dir $bin

    runHook postInstall
  '';

  preFixup = preFixup + ''
    while read file; do
      cat $file ${removeExpr removeReferences} > $file.tmp
      mv $file.tmp $file
      chmod +x $file
    done < <(find $bin/bin -type f 2>/dev/null)
  '';

  disallowedReferences = lib.optional (!allowGoReference) go
    ++ lib.optional (!dontRenameImports) govers;

  passthru = passthru // lib.optionalAttrs (goPackageAliases != []) { inherit goPackageAliases; };

  enableParallelBuilding = enableParallelBuilding;

  # I prefer to call this dev but propagatedBuildInputs expects $out to exist
  outputs = [ "out" "bin" ];

  meta = {
    # Add default meta information
    platforms = lib.platforms.all;
  } // meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.emery lib.maintainers.lethalman ];
  };
})
