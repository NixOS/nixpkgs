{ go, govers, parallel, lib, fetchgit, fetchhg, fetchbzr, rsync, removeReferencesTo }:

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

# Extra gopaths containing src subfolder
# with sources to include in the gopath
, extraSrcPaths ? [ ]

# go2nix dependency file
, goDeps ? null

, dontRenameImports ? false

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, meta ? {}, ... } @ args':

if disabled then throw "${name} not supported for go ${go.meta.branch}" else

with builtins;

let
  args = lib.filterAttrs (name: _: name != "extraSrcs") args';

  removeReferences = [ ] ++ lib.optional (!allowGoReference) go;

  removeExpr = refs: ''remove-references-to ${lib.concatMapStrings (ref: " -t ${ref}") refs}'';

  dep2src = goDep:
    {
      inherit (goDep) goPackagePath;
      src = if goDep.fetch.type == "git" then
        fetchgit {
          inherit (goDep.fetch) url rev sha256;
        }
      else if goDep.fetch.type == "hg" then
        fetchhg {
          inherit (goDep.fetch) url rev sha256;
        }
      else if goDep.fetch.type == "bzr" then
        fetchbzr {
          inherit (goDep.fetch) url rev sha256;
        }
      else abort "Unrecognized package fetch type: ${goDep.fetch.type}";
    };

  importGodeps = { depsFile }:
    map dep2src (import depsFile);

  goPath = if goDeps != null then importGodeps { depsFile = goDeps; } ++ extraSrcs
                             else extraSrcs;
in

go.stdenv.mkDerivation (
  (builtins.removeAttrs args [ "goPackageAliases" "disabled" ]) // {

  inherit name;
  nativeBuildInputs = [ removeReferencesTo go parallel ]
    ++ (lib.optional (!dontRenameImports) govers) ++ nativeBuildInputs;
  buildInputs = [ go ] ++ buildInputs;

  configurePhase = args.configurePhase or ''
    runHook preConfigure

    # Extract the source
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/$(dirname "$goPackagePath")"
    mv "$sourceRoot" "go/src/$goPackagePath"

  '' + lib.flip lib.concatMapStrings goPath ({ src, goPackagePath }: ''
    mkdir goPath
    (cd goPath; unpackFile "${src}")
    mkdir -p "go/src/$(dirname "${goPackagePath}")"
    chmod -R u+w goPath/*
    mv goPath/* "go/src/${goPackagePath}"
    rmdir goPath

  '') + (lib.optionalString (extraSrcPaths != []) ''
    ${rsync}/bin/rsync -a ${lib.concatMapStrings (p: "${p}/src") extraSrcPaths} go

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
      . $TMPDIR/buildFlagsArray
      echo "$d" | grep -q "\(/_\|examples\|Godeps\)" && return 0
      [ -n "$excludedPackages" ] && echo "$d" | grep -q "$excludedPackages" && return 0
      local OUT
      if ! OUT="$(go $cmd $buildFlags "''${buildFlagsArray[@]}" -v $d 2>&1)"; then
        if ! echo "$OUT" | grep -qE '(no( buildable| non-test)?|build constraints exclude all) Go (source )?files'; then
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
        find "$goPackagePath" -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort | uniq
        popd >/dev/null
      fi
    }

    if [ ''${#buildFlagsArray[@]} -ne 0 ]; then
      declare -p buildFlagsArray > $TMPDIR/buildFlagsArray
    else
      touch $TMPDIR/buildFlagsArray
    fi
    export -f buildGoDir # parallel needs to see the function
    if [ -z "$enableParallelBuilding" ]; then
        export NIX_BUILD_CORES=1
    fi
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
    find $bin/bin -type f -exec ${removeExpr removeReferences} '{}' + || true
  '';

  shellHook = ''
    d=$(mktemp -d "--suffix=-$name")
  '' + toString (map (dep: ''
     mkdir -p "$d/src/$(dirname "${dep.goPackagePath}")"
     ln -s "${dep.src}" "$d/src/${dep.goPackagePath}"
  ''
  ) goPath) + ''
    export GOPATH=${lib.concatStringsSep ":" ( ["$d"] ++ ["$GOPATH"] ++ ["$PWD"] ++ extraSrcPaths)}
  '';

  disallowedReferences = lib.optional (!allowGoReference) go
    ++ lib.optional (!dontRenameImports) govers;

  passthru = passthru //
    { inherit go; } //
    lib.optionalAttrs (goPackageAliases != []) { inherit goPackageAliases; };

  enableParallelBuilding = enableParallelBuilding;

  # I prefer to call this dev but propagatedBuildInputs expects $out to exist
  outputs = args.outputs or [ "bin" "out" ];

  meta = {
    # Add default meta information
    platforms = go.meta.platforms or lib.platforms.all;
  } // meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.ehmry lib.maintainers.lethalman ];
  };
})
