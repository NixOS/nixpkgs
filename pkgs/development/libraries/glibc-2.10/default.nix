{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
, gccCross ? null
}:

let
  build = import ./common.nix;
  cross = if gccCross != null then gccCross.target else null;
in
  build cross ({
    name = "glibc";

    inherit fetchurl stdenv kernelHeaders installLocales profilingLibraries
      gccCross;

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

        dontStrip = 1
      '';
   }
   else {}))
