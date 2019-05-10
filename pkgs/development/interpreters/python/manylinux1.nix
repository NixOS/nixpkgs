{stdenv, pkgs}:

with stdenv.lib;
with pkgs;

rec {
  # To be manylinux1 compatible, we have to be able to link against any of the libraries below (PEP 513)
  # https://www.python.org/dev/peps/pep-0513
  # The map shows which libraries come from which packages.
  libraryMap = {
    "libpanelw.so.5" = ncurses5;
    "libncursesw.so.5" = ncurses5;
    "libgcc_s.so.1" = glibc;
    "libstdc++.so.6" = gcc7.cc;
    "libm.so.6" = glibc;
    "libdl.so.2" = glibc;
    "librt.so.1" = glibc;
    "libcrypt.so.1" = glibc;
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
  };

  libs = attrValues libraryMap;
  desiredLibraries = attrNames libraryMap;

  package = runCommand "manylinux1_libs" {buildInputs = libs;} ''
    mkdir -p $out/lib
    num_found=0

    IFS=:
    export DESIRED_LIBRARIES=${concatStringsSep ":" desiredLibraries}
    export LIBRARY_PATH=${makeLibraryPath libs}
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

    num_desired=${toString (length desiredLibraries)}
    echo "Found $num_found of $num_desired libraries"
    if [ "$num_found" -ne "$num_desired" ]; then
      echo "Error: not all desired libraries were found"
      exit 1
    fi
  '';
}
