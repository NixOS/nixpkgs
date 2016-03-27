{ lib, stdenv, fetchurl, linuxHeaders
, installLocales ? true
, profilingLibraries ? false
, gccCross ? null
, withGd ? false, gd ? null, libpng ? null
}:

assert stdenv.cc.isGNU;

let
  build = import ./common.nix;
  cross = if gccCross != null then gccCross.target else null;
in
  build cross ({
    name = "glibc" + lib.optionalString withGd "-gd";

    inherit lib stdenv fetchurl linuxHeaders installLocales
      profilingLibraries gccCross withGd gd libpng;

    builder = ./builder.sh;

    # When building glibc from bootstrap-tools, we need libgcc_s at RPATH for
    # any program we run, because the gcc will have been placed at a new
    # store path than that determined when built (as a source for the
    # bootstrap-tools tarball)
    # Building from a proper gcc staying in the path where it was installed,
    # libgcc_s will not be at {gcc}/lib, and gcc's libgcc will be found without
    # any special hack.
    preInstall = if cross != null then "" else ''
      if [ -f ${stdenv.cc.cc}/lib/libgcc_s.so.1 ]; then
          mkdir -p $out/lib
          cp ${stdenv.cc.cc}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so.1
          # the .so It used to be a symlink, but now it is a script
          cp -a ${stdenv.cc.cc}/lib/libgcc_s.so $out/lib/libgcc_s.so
      fi
    '';

    separateDebugInfo = true;

    meta.description = "The GNU C Library";
  }

  //

  (if cross != null
   then {
      preConfigure = ''
        sed -i s/-lgcc_eh//g "../$sourceRoot/Makeconfig"

        cat > config.cache << "EOF"
        libc_cv_forced_unwind=yes
        libc_cv_c_cleanup=yes
        libc_cv_gnu89_inline=yes
        # Only due to a problem in gcc configure scripts:
        libc_cv_sparc64_tls=${if cross.withTLS then "yes" else "no"}
        EOF
        export BUILD_CC=gcc
        export CC="$crossConfig-gcc"
        export AR="$crossConfig-ar"
        export RANLIB="$crossConfig-ranlib"

        dontStrip=1
      '';

      # To avoid a dependency on the build system 'bash'.
      preFixup = ''
        rm $out/bin/{ldd,tzselect,catchsegv,xtrace}
      '';
    }
   else {}))
