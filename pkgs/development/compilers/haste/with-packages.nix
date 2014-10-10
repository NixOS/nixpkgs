{ stdenv, haskellCompiler, packages, buildEnv, makeWrapper, ignoreCollisions ? false, mkHtags ? false, mkHscope ? false,
  mkHoogledb ? false }:
let
  haste = haskellCompiler;
in

# This is a wrapper that packs a HASTE together with a collection of packages.

# It's probably a good idea to include the library "ghc-paths" in the
# compiler environment, because we have a specially patched version of
# that package in Nix that honors these environment variables
#
#   NIX_HASTE
#   NIX_HASTEPKG
#   NIX_HASTE_DOCDIR
#   NIX_HASTE_LIBDIR
#
# instead of hard-coding the paths. The wrapper sets these variables
# appropriately to configure ghc-paths to point back to the wrapper
# instead of to the pristine HASTE package, which doesn't know any of the
# additional libraries.
# Note: the package is called ghc-paths, but is patched specifically for haste.
#
#
# A good way to import the environment set by the wrapper below into
# your shell is to add the following snippet to your ~/.bashrc:
#
#   if [ -e /etc/profile.d/haste-env.sh ]; then
#     source /etc/profile.d/haste-env.sh
#   fi
#
# Some shell environments pick up the script automatically, though.
#
# You can also directly execute a command within the environment of the
# wrapper by:
#
# nix-haste-env-exec your_command_foo
#
#
# And, there is a script to wrap a command within the environment. The
# script is mainly intended to be used in other nix expressions.
# The script is actually makeWrapper with pre-set environment variables.
# So it can be used like makeWrapper. It is found at:
#
# $out/nix-build-helpers/nix-haste-env-wrapper
#

let
  libDir           = "$out/lib/haste-${haste.version}";
  packageCfgDir    = "${libDir}/packages";
  isHaskellPkg     = x: (x ? pname) && (x ? version);
  wrapperArguments =
    prefix:
    splitter:
    postfix:
    ''
    ${prefix}"NIX_HASTE_HASKELL_ENVIRONMENT"${splitter}"$out"${postfix}
    ${prefix}"NIX_HASTEC"${splitter}"$out/bin/ghc"${postfix}
    ${prefix}"NIX_HASTE_PKG"${splitter}"$out/bin/ghc-pkg"${postfix}
    ${prefix}"NIX_HASTE_PACKAGE_PATH"${splitter}"${packageCfgDir}"${postfix}
    '' + (if !mkHscope then "" else ''
    ${prefix}"NIX_HASTE_HASKELL_HSCOPE"${splitter}"$out/nix-build-helpers/haskell/hscope.db"${postfix}
    '') + (if !mkHtags then "" else ''
    ${prefix}"NIX_HASTE_HASKELL_HTAGS"${splitter}"$out/nix-build-helpers/haskell/htags.db"${postfix}
    '') + (if !mkHoogledb then "" else ''
    ${prefix}"NIX_HASTE_HASKELL_HOOGLEDB"${splitter}"$out/nix-build-helpers/haskell/hoogle.db"${postfix}
    '') + ''
    '';
  writeTextFile =
    name: # the full name of the output file
    text: # content of the file
    executable: # run chmod +x ?
    ''
    mkdir -p "$(dirname "${name}")"
    cat >> ${name} <<EOF_NIX_HASKELL_CONFIGURATION
    ${text}
    EOF_NIX_HASKELL_CONFIGURATION
    '' + (if !executable then "" else ''
    chmod +x "${name}"
    '');

in
buildEnv {
  name = "haste-withPackages-${haste.name}";
  paths = stdenv.lib.filter isHaskellPkg (stdenv.lib.closePropagation packages) ++ [haste];
  inherit ignoreCollisions;
  postBuild = ''
    . ${makeWrapper}/nix-support/setup-hook

    #
    # all binaries will be wrapped; make space in $out/bin for the wrappers
    #
    TEMP_BIN_DIR=$(mktemp -d --dry-run --tmpdir=$TMPDIR)
    if [[ -L "$out/bin" && -d "$out/bin" ]]; then
      mkdir $TEMP_BIN_DIR
      for i in `ls $out/bin`; do
        ln -s $(readlink $out/bin)/$i $TEMP_BIN_DIR
      done
      rm -f $out/bin
    else
      mv $out/bin $TEMP_BIN_DIR
    fi
    mkdir -p $out/bin


    #
    # make sure $out/etc/profile.d is a writable directory, not a link into another package
    #
    if [[ -L "$out/etc" && -d "$out/etc" ]]; then
      TEMP_ETC_DIR=$(mktemp -d --tmpdir=$TMPDIR)
      for i in `ls $out/etc`; do
        ln -s $(readlink $out/etc)/$i $TEMP_ETC_DIR
      done
      rm -f $out/etc
      mv $TEMP_ETC_DIR $out/etc
    fi

    if [[ -L "$out/etc/profile.d" && -d "$out/etc/profile.d" ]]; then
      TEMP_PROFILE_DIR=$(mktemp -d --tmpdir=$TMPDIR)
      for i in `ls $out/etc/profile.d`; do
        ln -s $(readlink $out/etc/profile.d)/$i $TEMP_PROFILE_DIR
      done
      rm -f $out/etc/profile.d
      mv $TEMP_PROFILE_DIR $out/etc/profile.d
    fi

    #
    # generate helper functions for using the wrapped HASTE
    #
    '' + (writeTextFile "$out/etc/profile.d/haste-env.sh" (wrapperArguments "export " "=" "") false) + ''
    '' + (writeTextFile "$out/bin/nix-haste-env-exec" (''
                                                     #! $SHELL -e
                                                     '' + (wrapperArguments "export " "=" "") + ''
                                                     exec "\$@"
                                                     '') true) + ''
    '' + (writeTextFile "$out/nix-build-helpers/nix-haste-env-wrapper" (''
                                                     #! $SHELL -e
                                                     . ${makeWrapper}/nix-support/setup-hook
                                                     echo "\$@"
                                                     makeWrapper "\$@" \
                                                     '' + (wrapperArguments "--set " " " " \\") + ''
                                                     '') true) + ''



    #
    # wrap all binaries provided by HASTE and by the library packages
    #
    for prg in `ls "$TEMP_BIN_DIR"`; do
      TARGET=$(readlink -f "$TEMP_BIN_DIR/$prg")
      rm "$TEMP_BIN_DIR/$prg"
      $out/nix-build-helpers/nix-haste-env-wrapper $TARGET $out/bin/$prg
    done


    #
    # generate databases that contain information about HASTE and the library packages.
    #
    # HACK: make sure package.cache is writable
    if [ ! -h $out/lib ] && [ ! -h $out/lib/haste-${haste.version} ] && \
       [ ! -h $out/lib/haste-${haste.version}/packages ]; then
      if [ -e $out/lib/haste-${haste.version}/packages/package.cache ] && \
         [ -h $out/lib/haste-${haste.version}/packages/package.cache ]; then
        rm $out/lib/haste-${haste.version}/packages/package.cache
      fi
      $out/bin/haste-pkg --package-db=$out/lib/haste-${haste.version}/packages recache
    fi

    # TODO: generate ctag, cscope and hoogle databases
    # https://gist.github.com/4z3/5c8507b84efaba648a6d
  '';
}
