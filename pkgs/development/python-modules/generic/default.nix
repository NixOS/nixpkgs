/* This function provides a generic Python package builder.  It is
   intended to work with packages that use `setuptools'
   (http://pypi.python.org/pypi/setuptools/), which represents a large
   number of Python packages nowadays.  */

{ python, setuptools, makeWrapper, lib }:

{ name, namePrefix ? "python-", src, meta, patches ? []
, installCommand ? ""
, doCheck ? true, checkPhase ? "python setup.py test"
, postInstall ? ""
, ... } @ attrs:

let
    defaultInstallCommand = ''easy_install --prefix="$out" .'';

    # Return the list of recursively propagated build inputs of PKG.
    recursiveBuildInputs =
      pkg:
        [ pkg ] ++
        (if pkg ? propagatedBuildNativeInputs
         then lib.concatLists (map recursiveBuildInputs
                                   pkg.propagatedBuildNativeInputs)
         else []);

in

python.stdenv.mkDerivation (
  # Keep extra attributes from ATTR, e.g., `patchPhase', etc.
  attrs

  //

  (rec {
  inherit src meta patches doCheck checkPhase;

  name = namePrefix + attrs.name;

  buildInputs = [ python setuptools makeWrapper ] ++
    (if attrs ? buildInputs then attrs.buildInputs else []);

  propagatedBuildInputs = [ setuptools ] ++
    (if attrs ? propagatedBuildInputs
     then attrs.propagatedBuildInputs
     else []);

  buildPhase = "true";

  # XXX: Should we run `easy_install --always-unzip'?  It doesn't seem
  # to have a noticeable impact on small scripts.
  installPhase = ''
    ensureDir "$out/lib/${python.libPrefix}/site-packages"

    echo "installing \`${name}' with \`easy_install'..."
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    ${if installCommand == "" then defaultInstallCommand else installCommand}

    ${postInstall}
  '';

  postFixup = ''
    # Wrap scripts that are under `{s,}bin/' so that they get the right
    # $PYTHONPATH.
    for i in "$out/bin/"* "$out/sbin/"*
    do
      if head -n1 "$i" | grep -q "${python}"
      then
          echo "wrapping \`$i'..."

          # Compute a $PATH prefix for the program.
          program_PATH=""
          ${lib.concatStrings
            (map (path:
                  ''if [ -d "${path}/bin" ]
                    then
                        program_PATH="${path}/bin'' + "\$" + ''{program_PATH:+:}$program_PATH"
                    fi
                   '')
                 (lib.concatMap recursiveBuildInputs propagatedBuildInputs))}

          wrapProgram "$i"                          \
            --prefix PYTHONPATH ":"                 \
            ${lib.concatStringsSep ":"
               ([ "$out/lib/${python.libPrefix}/site-packages" ] ++
                (map (path: path + "/lib/${python.libPrefix}/site-packages")
                     (lib.concatMap recursiveBuildInputs
                                    propagatedBuildInputs)))} \
            --prefix PATH ":" "$program_PATH"

      fi
    done

    # If a user installs a Python package, she probably also wants its
    # dependencies in the user environment (since Python modules don't
    # have something like an RPATH, so the only way to find the
    # dependencies is to have them in the PYTHONPATH variable).
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';
}))
