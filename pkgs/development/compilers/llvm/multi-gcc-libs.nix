{ runCommand
, gcc64
, gcc32
}:

let
  combine = basegcc: runCommand "combine-gcc-libc" {} ''
    mkdir -p $out
    cp -r ${basegcc.cc}/lib $out/lib

    chmod u+rw -R $out/lib
    cp -r ${basegcc.libc}/lib/* $(ls -d $out/lib/gcc/*/*)
  '';

  combine-gcc-libc = runCommand "gcc-multi-libs" {
    passthru = {
      inherit (gcc64) version;
      lib = combine-gcc-libc;
    };
  } ''
    mkdir -p $out/lib{,64}/gcc
    ln -s ${combine gcc64}/lib/gcc/* $out/lib64/gcc/
    ln -s ${combine gcc32}/lib/gcc/* $out/lib/gcc/
    # needed to force clang to recognize GCC 32-bit installation
    ln -s $out/lib/gcc/i686-unknown-linux-gnu $out/lib/gcc/i686-pc-linux-gnu
  '';

in combine-gcc-libc
