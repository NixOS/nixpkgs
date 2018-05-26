{ runCommand,
clang,
gcc64,
gcc32,
glibc_multi
}:

let
  combine = basegcc: runCommand "combine-gcc-libc" {} ''
    mkdir -p $out
    cp -r ${basegcc.cc}/lib $out/lib

    chmod u+rw -R $out/lib
    cp -r ${basegcc.libc}/lib/* $(ls -d $out/lib/gcc/*/*)
  '';
  gcc_multi_sysroot = runCommand "gcc-multi-sysroot" {} ''
    mkdir -p $out/lib/gcc

    ln -s ${combine gcc64}/lib/gcc/* $out/lib/gcc/
    ln -s ${combine gcc32}/lib/gcc/* $out/lib/gcc/
    # XXX: This shouldn't be needed, clang just doesn't look for "i686-unknown"
    ln -s $out/lib/gcc/i686-unknown-linux-gnu $out/lib/gcc/i686-pc-linux-gnu


    # includes
    ln -s ${glibc_multi.dev}/include $out/

    # dynamic linkers
    mkdir -p $out/lib/32
    ln -s ${glibc_multi.out}/lib/ld-linux* $out/lib
    ln -s ${glibc_multi.out}/lib/32/ld-linux* $out/lib/32/
  '';

  clangMulti = clang.override {
    # Only used for providing expected structure re:dynamic linkers, AFAIK
    # Most of the magic is done by setting the --gcc-toolchain option below
    libc = gcc_multi_sysroot;

    bintools = clang.bintools.override {
      libc = gcc_multi_sysroot;
    };

    extraBuildCommands = ''
      sed -e '$a --gcc-toolchain=${gcc_multi_sysroot}' -i $out/nix-support/libc-cflags
    '';
  };

in clangMulti
