/* This function provides a generic Python package builder.  It is
   intended to work with packages that use `setuptools'
   (http://pypi.python.org/pypi/setuptools/), which represents a large
   number of Python packages nowadays.  */

{ python, setuptools, makeWrapper, lib }:

{ name, namePrefix ? "python-", src, meta, patches ? []
, doCheck ? true, ... } @ attrs:

let
    # Return the list of recursively propagated build inputs of PKG.
    recursiveBuildInputs =
      pkg:
        [ pkg ] ++
        (if pkg ? propagatedBuildInputs
         then lib.concatLists (map recursiveBuildInputs
                                   pkg.propagatedBuildInputs)
         else []);

in

python.stdenv.mkDerivation (
  # Keep extra attributes from ATTR, e.g., `patchPhase', etc.
  attrs

  //

  (rec {
  inherit src meta patches doCheck;

  name = namePrefix + attrs.name;

  buildInputs = [ python setuptools makeWrapper ] ++
    (if attrs ? buildInputs then attrs.buildInputs else []);

  propagatedBuildInputs = [ setuptools ] ++
    (if attrs ? propagatedBuildInputs
     then attrs.propagatedBuildInputs
     else []);

  buildPhase = "true";

  # Many packages, but not all, support this.
  checkPhase = "python setup.py test";

  # XXX: Should we run `easy_install --always-unzip'?  It doesn't seem
  # to have a noticeable impact on small scripts.
  installPhase = ''
    ensureDir "$out/lib/${python.libPrefix}/site-packages"

    echo "installing \`${name}' with \`easy_install'..."
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    easy_install --prefix="$out" .
  '';

  postFixup = ''
    # Wrap scripts that are under `{s,}bin/' so that they get the right
    # $PYTHONPATH.
    for i in "$out/bin/"* "$out/sbin/"*
    do
      if head -n1 "$i" | grep -q "${python}"
      then
          echo "wrapping \`$i'..."
          wrapProgram "$i"                          \
            --prefix PYTHONPATH ":"                 \
            ${lib.concatStringsSep ":"
               ([ "$out/lib/${python.libPrefix}/site-packages" ] ++
                (map (path: path + "/lib/${python.libPrefix}/site-packages")
                     (lib.concatMap recursiveBuildInputs
                                    propagatedBuildInputs)))}
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
