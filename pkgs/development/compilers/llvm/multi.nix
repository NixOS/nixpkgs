{
  runCommand,
  clang,
  gcc64,
  gcc32,
  glibc_multi,
}:

let
  combine =
    basegcc:
    runCommand "combine-gcc-libc" { } ''
      mkdir -p $out
      cp -r ${basegcc.cc}/lib $out/lib

      chmod u+rw -R $out/lib
      cp -r ${basegcc.libc}/lib/* $(ls -d $out/lib/gcc/*/*)
    '';
  gcc_multi_sysroot =
    runCommand "gcc-multi-sysroot"
      {
        passthru = {
          inherit (gcc64) version;
          lib = gcc_multi_sysroot;
        };
      }
      ''
        mkdir -p $out/lib{,64}/gcc

        ln -s ${combine gcc64}/lib/gcc/* $out/lib64/gcc/
        ln -s ${combine gcc32}/lib/gcc/* $out/lib/gcc/
        # XXX: This shouldn't be needed, clang just doesn't look for "i686-unknown"
        ln -s $out/lib/gcc/i686-unknown-linux-gnu $out/lib/gcc/i686-pc-linux-gnu


        # includes
        mkdir -p $out/include
        ln -s ${glibc_multi.dev}/include/* $out/include
        ln -s ${gcc64.cc}/include/c++ $out/include/c++

        # dynamic linkers
        mkdir -p $out/lib/32
        ln -s ${glibc_multi.out}/lib/ld-linux* $out/lib
        ln -s ${glibc_multi.out}/lib/32/ld-linux* $out/lib/32/
      '';

  clangMulti = clang.override {
    # Only used for providing expected structure re:dynamic linkers, AFAIK Most
    # of the magic is done by setting the --gcc-toolchain option via
    # `gccForLibs`.
    libc = gcc_multi_sysroot;

    bintools = clang.bintools.override {
      libc = gcc_multi_sysroot;
    };

    gccForLibs = gcc_multi_sysroot // {
      inherit (glibc_multi) libgcc;
      langCC =
        assert
          (gcc64.cc.langCC != gcc32.cc.langCC)
          -> throw "(gcc64.cc.langCC=${gcc64.cc.langCC}) != (gcc32.cc.langCC=${gcc32.cc.langCC})";
        gcc64.cc.langCC;
    };
  };

in
clangMulti
