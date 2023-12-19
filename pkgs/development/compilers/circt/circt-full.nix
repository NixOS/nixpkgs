{ symlinkJoin, circt }:
symlinkJoin {
  name = "circt-full";
  paths = [
    circt
    circt.lib
    circt.dev

    circt.llvm
    circt.llvm.lib
    circt.llvm.dev
  ];

  inherit (circt) meta;
}
