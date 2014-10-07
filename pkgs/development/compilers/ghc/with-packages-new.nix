{ stdenv, haskellCompiler, packages, buildEnv, makeWrapper, ignoreCollisions ? false, mkHtags ? false, mkHscope ? false,
  mkHoogledb ? false }:
let
  ghc = haskellCompiler;
in

# This is a wrapper that packs a GHC together with a collection of packages.

# This wrapper works only with GHC 6.12 or later.
assert stdenv.lib.versionOlder "6.12" ghc.version;

# It's probably a good idea to include the library "ghc-paths" in the
# compiler environment, because we have a specially patched version of
# that package in Nix that honors these environment variables
#
#   NIX_GHC
#   NIX_GHCPKG
#   NIX_GHC_DOCDIR
#   NIX_GHC_LIBDIR
#
# instead of hard-coding the paths. The wrapper sets these variables
# appropriately to configure ghc-paths to point back to the wrapper
# instead of to the pristine GHC package, which doesn't know any of the
# additional libraries.
#
#
# A good way to import the environment set by the wrapper below into
# your shell is to add the following snippet to your ~/.bashrc:
#
#   if [ -e /etc/profile.d/ghc-env.sh ]; then
#     source /etc/profile.d/ghc-env.sh
#   fi
#
# Some shell environments pick up the script automatically, though.
# 
# You can also directly execute a command within the environment of the
# wrapper by:
#
# nix-ghc-env-exec your_command_foo
#
#
# And, there is a script to wrap a command within the environment. The
# script is mainly intended to be used in other nix expressions.
# The script is actually makeWrapper with pre-set environment variables.
# So it can be used like makeWrapper. It is found at:
#
# $out/nix-build-helpers/nix-ghc-env-wrapper
#

let
  ghc761OrLater    = stdenv.lib.versionOlder "7.6.1" ghc.version;
  packageDBFlag    = if ghc761OrLater then "--global-package-db" else "--global-conf";
  libDir           = "$out/lib/ghc-${ghc.version}";
  docDir           = "$out/share/doc/ghc/html";
  packageCfgDir    = "${libDir}/package.conf.d";
  isHaskellPkg     = x: (x ? pname) && (x ? version);
  wrapperArguments =
    prefix:
    splitter:
    postfix:
    ''
    ${prefix}"NIX_GHC_HASKELL_ENVIRONMENT"${splitter}"$out"${postfix}
    ${prefix}"NIX_GHC"${splitter}"$out/bin/ghc"${postfix}
    ${prefix}"NIX_GHCPKG"${splitter}"$out/bin/ghc-pkg"${postfix}
    ${prefix}"NIX_GHC_DOCDIR"${splitter}"${docDir}"${postfix}
    ${prefix}"NIX_GHC_LIBDIR"${splitter}"${libDir}"${postfix}
    ${prefix}"NIX_GHC_PACKAGE_PATH"${splitter}"${packageCfgDir}"${postfix}
    '' + (if !mkHscope then "" else ''
    ${prefix}"NIX_GHC_HASKELL_HSCOPE"${splitter}"$out/nix-build-helpers/haskell/hscope.db"${postfix}
    '') + (if !mkHtags then "" else ''
    ${prefix}"NIX_GHC_HASKELL_HTAGS"${splitter}"$out/nix-build-helpers/haskell/htags.db"${postfix}
    '') + (if !mkHoogledb then "" else ''
    ${prefix}"NIX_GHC_HASKELL_HOOGLEDB"${splitter}"$out/nix-build-helpers/haskell/hoogle.db"${postfix}
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

  # create wrapper for GHC; GHC needs a dedicated wrapper which sets the global-package-db by
  # specifying GHC_PACKAGE_PATH
  wrapGHC = inputFile: outputFile:
    writeTextFile outputFile
      (''
       #! ${stdenv.shell} -e
       '' + (wrapperArguments "export " "=" "") + ''
       if [ ! -z "\$GHC_PACKAGE_PATH" ]; then
         if [ "${"\\\${GHC_PACKAGE_PATH: -1}"}" == ":" ]; then
           export GHC_PACKAGE_PATH="\$GHC_PACKAGE_PATH""\$NIX_GHC_PACKAGE_PATH"
         fi
       else
         export GHC_PACKAGE_PATH="\$NIX_GHC_PACKAGE_PATH"
       fi
       exec ${inputFile} "\$@"
       '') true;

in
buildEnv {
  name = "ghc-withPackages-${ghc.name}";
  paths = stdenv.lib.filter isHaskellPkg (stdenv.lib.closePropagation packages) ++ [ghc];
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
    # generate helper functions for using the wrapped GHC
    #
    '' + (writeTextFile "$out/etc/profile.d/ghc-env.sh" (wrapperArguments "export " "=" "") false) + ''
    '' + (writeTextFile "$out/bin/nix-ghc-env-exec" (''
                                                     #! $SHELL -e
                                                     '' + (wrapperArguments "export " "=" "") + ''
                                                     exec "\$@"
                                                     '') true) + ''
    '' + (writeTextFile "$out/nix-build-helpers/nix-ghc-env-wrapper" (''
                                                     #! $SHELL -e
                                                     . ${makeWrapper}/nix-support/setup-hook
                                                     makeWrapper "\$@" \
                                                     '' + (wrapperArguments "--set " " " " \\") + ''
                                                     '') true) + ''


    #
    # special treatment for binaries in GHC package
    #
    # wrap "ghc" with dedicated wrapper that sets GHC_PACKAGE_PATH
    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      rm "$TEMP_BIN_DIR/$prg"
    done
    '' + (wrapGHC "${ghc}/bin/ghc" "$out/bin/ghc") + ''
    '' + (wrapGHC "${ghc}/bin/ghci" "$out/bin/ghci") + ''
    '' + (wrapGHC "${ghc}/bin/ghc-${ghc.version}" "$out/bin/ghc-${ghc.version}") + ''
    '' + (wrapGHC "${ghc}/bin/ghci-${ghc.version}" "$out/bin/ghci-${ghc.version}") + ''

    for prg in runghc runhaskell; do
      rm "$TEMP_BIN_DIR/$prg"
      $out/nix-build-helpers/nix-ghc-env-wrapper ${ghc}/bin/$prg $out/bin/$prg \
        --add-flags "-f $out/bin/ghc"
    done

    # ghc-pkg is a wrapper itself, which only adds the global-package-db;
    # to avoid patching the wrapper, and to also avoid nested wrapping at the same time,
    # the wrapper creation targets the unwrapped ghc-pkg
    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      rm "$TEMP_BIN_DIR/$prg"
      $out/nix-build-helpers/nix-ghc-env-wrapper ${ghc}/lib/ghc-${ghc.version}/bin/ghc-pkg $out/bin/$prg \
        --add-flags "--global-package-db \"\$NIX_GHC_PACKAGE_PATH\""
    done

    #
    # wrap all binaries provided by the library packages, that is all packages except GHC
    #
    for prg in `ls "$TEMP_BIN_DIR"`; do
      TARGET=$(readlink -f "$TEMP_BIN_DIR/$prg")
      rm "$TEMP_BIN_DIR/$prg"
      $out/nix-build-helpers/nix-ghc-env-wrapper $TARGET $out/bin/$prg
    done


    #
    # generate databases that contain information about the GHC and the library packages.
    #
    # HACK: make sure package.cache is writable
    if [ ! -h $out/lib ] && [ ! -h $out/lib/ghc-${ghc.version} ] && \
       [ ! -h $out/lib/ghc-${ghc.version}/package.conf.d ]; then
      if [ -e $out/lib/ghc-${ghc.version}/package.conf.d/package.cache ] && \
         [ -h $out/lib/ghc-${ghc.version}/package.conf.d/package.cache ]; then
        rm $out/lib/ghc-${ghc.version}/package.conf.d/package.cache
      fi
      $out/bin/ghc-pkg --package-db=$out/lib/ghc-${ghc.version}/package.conf.d recache
    fi

    # TODO: generate ctag, cscope and hoogle databases
    # https://gist.github.com/4z3/5c8507b84efaba648a6d
  '';
}
