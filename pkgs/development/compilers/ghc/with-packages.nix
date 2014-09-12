{ stdenv, ghc, packages, buildEnv, makeWrapper, ignoreCollisions ? false, mkHtags ? false, mkHscope ? false,
  mkHoogledb ? false }:

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
#   if [ -e ~/.nix-profile/bin/nix-ghc-env-set ]; then
#     source ~/.nix-profile/bin/nix-ghc-env-set
#   fi
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
    ${prefix}"NIX_HASKELL_ENVIRONMENT"${splitter}"$out"${postfix}
    ${prefix}"NIX_GHC"${splitter}"$out/bin/ghc"${postfix}
    ${prefix}"NIX_GHCPKG"${splitter}"$out/bin/ghc-pkg"${postfix}
    ${prefix}"NIX_GHC_DOCDIR"${splitter}"${docDir}"${postfix}
    ${prefix}"NIX_GHC_LIBDIR"${splitter}"${libDir}"${postfix}
    '' + (if !mkHscope then "" else ''
    ${prefix}"NIX_HASKELL_HSCOPE"${splitter}"$out/nix-build-helpers/haskell/hscope.db"${postfix}
    '') + (if !mkHtags then "" else ''
    ${prefix}"NIX_HASKELL_HTAGS"${splitter}"$out/nix-build-helpers/haskell/htags.db"${postfix}
    '') + (if !mkHoogledb then "" else ''
    ${prefix}"NIX_HASKELL_HOOGLEDB"${splitter}"$out/nix-build-helpers/haskell/hoogle.db"${postfix}
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
  name = "haskell-env-${ghc.name}";
  paths = stdenv.lib.filter isHaskellPkg (stdenv.lib.closePropagation packages) ++ [ghc];
  inherit ignoreCollisions;
  postBuild = ''
    . ${makeWrapper}/nix-support/setup-hook

    #
    # all binaries will be wrapped; make space in $out/bin for the wrappers
    #
    if [[ -L "$out/bin" && -d "$out/bin" ]]; then
      mkdir $out/_tmp_bin
      for i in `ls $out/bin`; do
        ln -s $(readlink $out/bin)/$i $out/_tmp_bin/$i
      done
      rm -f $out/bin
    else
      mv $out/bin $out/_tmp_bin
    fi
    mkdir -p $out/bin


    #
    # generate helper functions for using the wrapped GHC
    #
    '' + (writeTextFile "$out/bin/nix-ghc-env-set" (wrapperArguments "export " "=" "") false) + ''
    '' + (writeTextFile "$out/bin/nix-ghc-env-exec" (''
                                                     #! $SHELL -e
                                                     '' + (wrapperArguments "export " "=" "") + ''
                                                     exec "\$@"
                                                     '') true) + ''
    '' + (writeTextFile "$out/nix-build-helpers/nix-ghc-env-wrapper" (''
                                                     #! $SHELL -e
                                                     . ${makeWrapper}/nix-support/setup-hook
                                                     echo "\$@"
                                                     makeWrapper "\$@" \
                                                     '' + (wrapperArguments "--set " " " " \\") + ''
                                                     '') true) + ''


    #
    # special treatment for binaries in GHC package
    #
    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      if [ -e $out/_tmp_bin/$prg ]; then
        rm $out/_tmp_bin/$prg
        $out/nix-build-helpers/nix-ghc-env-wrapper ${ghc}/bin/$prg $out/bin/$prg \
          --add-flags '"-B$NIX_GHC_LIBDIR"'
      if
    done

    for prg in runghc runhaskell; do
      if [ -e $out/_tmp_bin/$prg ]; then
        rm $out/_tmp_bin/$prg
        $out/nix-build-helpers/nix-ghc-env-wrapper ${ghc}/bin/$prg $out/bin/$prg \
          --add-flags "-f $out/bin/ghc"
      fi
    done

    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      if [ -e $out/_tmp_bin/$prg ]; then
        rm $out/_tmp_bin/$prg
        $out/nix-build-helpers/nix-ghc-env-wrapper ${ghc}/bin/$prg $out/bin/$prg \
          --add-flags "${packageDBFlag}=${packageCfgDir}"
      fi
    done


    #
    # wrap all binaries provided by the library packages, that is all packages except GHC
    #
    for prg in `ls $out/_tmp_bin`; do
      TARGET=$(readlink -f $out/_tmp_bin/$prg)
      rm -f $out/_tmp_bin/$prg
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
      $out/bin/ghc-pkg recache
    fi

    # TODO: generate ctag, cscope and hoogle databases
  '';
}
