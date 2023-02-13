{ lib, pkgs }:

let
  # Create a derivation that links all desired manylinux libraries
  createManyLinuxPackage = name: libs: let
    drvs = lib.unique (lib.attrValues libs);
    names = lib.attrNames libs;
  in pkgs.runCommand name {
    buildInputs = drvs;
  } ''
    mkdir -p $out/lib
    num_found=0

    IFS=:
    export DESIRED_LIBRARIES=${lib.concatStringsSep ":" names}
    export LIBRARY_PATH=${lib.makeLibraryPath drvs}
    for desired in $DESIRED_LIBRARIES; do
      for path in $LIBRARY_PATH; do
        if [ -e $path/$desired ]; then
          echo "FOUND $path/$desired"
          ln -s $path/$desired $out/lib/$desired
          num_found=$((num_found+1))
          break
        fi
      done
    done

    num_desired=${toString (lib.length names)}
    echo "Found $num_found of $num_desired libraries"
    if [ "$num_found" -ne "$num_desired" ]; then
      echo "Error: not all desired libraries were found"
      exit 1
    fi
  '';

  getLibOutputs = lib.mapAttrs (k: v: lib.getLib v);

  # https://www.python.org/dev/peps/pep-0599/
  manylinux2014Libs = getLibOutputs(with pkgs; {
    "libgcc_s.so.1" = glibc;
    "libstdc++.so.6" = stdenv.cc.cc;
    "libm.so.6" = glibc;
    "libdl.so.2" = glibc;
    "librt.so.1" = glibc;
    "libc.so.6" = glibc;
    "libnsl.so.1" = glibc;
    "libutil.so.1" = glibc;
    "libpthread.so.0" = glibc;
    "libresolv.so.2" = glibc;
    "libX11.so.6" = xorg.libX11;
    "libXext.so.6" = xorg.libXext;
    "libXrender.so.1" = xorg.libXrender;
    "libICE.so.6" = xorg.libICE;
    "libSM.so.6" = xorg.libSM;
    "libGL.so.1" = libGL;
    "libgobject-2.0.so.0" = glib;
    "libgthread-2.0.so.0" = glib;
    "libglib-2.0.so.0" = glib;
    });

  # https://www.python.org/dev/peps/pep-0571/
  manylinux2010Libs = manylinux2014Libs;

  # https://www.python.org/dev/peps/pep-0513/
  manylinux1Libs = getLibOutputs(manylinux2010Libs // (with pkgs; {
    "libpanelw.so.5" = ncurses5;
    "libncursesw.so.5" = ncurses5;
    "libcrypt.so.1" = libxcrypt;
    }));

in {
  # List of libraries that are needed for manylinux compatibility.
  # When using a wheel that is manylinux1 compatible, just extend
  # the `buildInputs` with one of these `manylinux` lists.
  # Additionally, add `autoPatchelfHook` to `nativeBuildInputs`.
  manylinux1 = lib.unique (lib.attrValues manylinux1Libs);
  manylinux2010 = lib.unique (lib.attrValues manylinux2010Libs);
  manylinux2014 = lib.unique (lib.attrValues manylinux2014Libs);

  # These are symlink trees to the relevant libs and are typically not needed
  # These exist so as to quickly test whether all required libraries are provided
  # by the mapped packages.
  manylinux1Package = createManyLinuxPackage "manylinux1" manylinux1Libs;
  manylinux2010Package = createManyLinuxPackage "manylinux2010" manylinux2010Libs;
  manylinux2014Package = createManyLinuxPackage "manylinux2014" manylinux2014Libs;
}
