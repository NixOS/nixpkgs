{ stdenv, fetchurl, kernelHeaders
, machHeaders ? null, hurdHeaders ? null, libpthreadHeaders ? null
, mig ? null, fetchgit ? null
, installLocales ? true
, profilingLibraries ? false
, gccCross ? null
, debugSymbols ? false
}:

assert stdenv.gcc.gcc != null;

let
  build = import ./common.nix;
  cross = if gccCross != null then gccCross.target else null;
in
  build cross ({
    name = "glibc${if debugSymbols then "-debug" else ""}";

    inherit fetchurl stdenv kernelHeaders installLocales profilingLibraries
      gccCross;

    builder = ./builder.sh;

    # When building glibc from bootstrap-tools, we need libgcc_s at RPATH for
    # any program we run, because the gcc will have been placed at a new
    # store path than that determined when built (as a source for the
    # bootstrap-tools tarball)
    # Building from a proper gcc staying in the path where it was installed,
    # libgcc_s will not be at {gcc}/lib, and gcc's libgcc will be found without
    # any special hack.
    preInstall = ''
      if [ -f ${stdenv.gcc.gcc}/lib/libgcc_s.so.1 ]; then
          mkdir -p $out/lib
          ln -s ${stdenv.gcc.gcc}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so.1
      fi
    '';

    meta.description = "The GNU C Library";
  }

  //

  (if debugSymbols
   then {
     # Build with debugging symbols, but leave optimizations on and don't
     # attempt to keep the build tree.
     dontStrip = true;
     dontCrossStrip = true;
     NIX_STRIP_DEBUG = 0;
   }
   else {})

  //

  (if hurdHeaders != null
   then rec {
     inherit machHeaders hurdHeaders libpthreadHeaders mig fetchgit;

     propagatedBuildInputs = [ machHeaders hurdHeaders libpthreadHeaders ];

     passthru = {
       # When building GCC itself `propagatedBuildInputs' above is not
       # honored, so we pass it here so that the GCC builder can do the right
       # thing.
       inherit propagatedBuildInputs;
     };
   }
   else { })

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
