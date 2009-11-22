{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
, cross ? null
, gccCross ? null
}:

let build = import ./common.nix;
in
  build ({
    name = "glibc" +
      stdenv.lib.optionalString (cross != null) "-${cross.config}";

    inherit fetchurl stdenv kernelHeaders installLocales profilingLibraries
      cross gccCross;

    builder = ./builder.sh;

    preInstall = ''
      ensureDir $out/lib
      ln -s ${stdenv.gcc.gcc}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so.1
    '';

    postInstall = ''
      rm $out/lib/libgcc_s.so.1
    '';

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
EOF
        export BUILD_CC=gcc
        export CC="$crossConfig-gcc"
        export AR="$crossConfig-ar"
        export RANLIB="$crossConfig-ranlib"

        # The host strip will destroy everything in the target binaries
        # otherwise.
        dontStrip=1
      '';
   }
   else {}))
