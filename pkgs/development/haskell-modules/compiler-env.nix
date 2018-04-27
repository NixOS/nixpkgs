{ buildPlatform, targetPlatform, lib, ghc }:

{ outDir
, enableSharedLibraries
}:

let
  inherit (builtins) typeOf;
  inherit (lib) optionalString versionOlder;

  isGhcjs = ghc.isGhcjs or false;
  isHaLVM = ghc.isHaLVM or false;
  packageDbFlag = if isGhcjs || isHaLVM || versionOlder "7.6" ghc.version
                  then "package-db"
                  else "package-conf";
  ghcCommand' = if isGhcjs then "ghcjs" else "ghc";
  ghcCommand = "${ghc}/bin/${ghc.targetPrefix}${ghcCommand'}";
in

''
  local packageConfDir="${outDir}/package.conf.d"
  mkdir -p "$packageConfDir"

  envConfigureFlags="--package-db=$packageConfDir"
  envGhcFlags="-${packageDbFlag}=$packageConfDir"

  for p in "''${pkgsHostHost[@]}" "''${pkgsHostTarget[@]}"; do
    if [ -d "$p/lib/${ghc.name}/package.conf.d" ]; then
      cp -f "$p/lib/${ghc.name}/package.conf.d/"*.conf $packageConfDir/
      continue
    fi
    if [ -d "$p/include" ]; then
      envConfigureFlags+=" --extra-include-dirs=$p/include"
    fi
    if [ -d "$p/lib" ]; then
      envConfigureFlags+=" --extra-lib-dirs=$p/lib"
    fi
''
# It is not clear why --extra-framework-dirs does work fine on Linux
+ optionalString (!buildPlatform.isDarwin || lib.versionAtLeast ghc.version "8.0") ''
    if [[ -d "$p/Library/Frameworks" ]]; then
      configureFlags+=" --extra-framework-dirs=$p/Library/Frameworks"
    fi
'' + ''
  done
''
# only use the links hack if we're actually building dylibs. otherwise, the
# "dynamic-library-dirs" point to nonexistent paths, and the ln command becomes
# "ln -s $out/lib/links", which tries to recreate the links dir and fails
+ (optionalString (targetPlatform.isDarwin && enableSharedLibraries) ''
  # Work around a limit in the macOS Sierra linker on the number of paths
  # referenced by any one dynamic library:
  #
  # Create a local directory with symlinks of the *.dylib (macOS shared
  # libraries) from all the dependencies.
  local dynamicLinksDir="${outDir}/lib/links"
  mkdir -p $dynamicLinksDir
  for d in $(grep dynamic-library-dirs "$packageConfDir/"*|awk '{print $2}'|sort -u); do
    ln -s "$d/"*.dylib $dynamicLinksDir
  done
  # Edit the local package DB to reference the links directory.
  for f in "$packageConfDir/"*.conf; do
    sed -i "s,dynamic-library-dirs: .*,dynamic-library-dirs: $dynamicLinksDir," $f
  done
'') + ''
  ${ghcCommand}-pkg --${packageDbFlag}="$packageConfDir" recache
''
