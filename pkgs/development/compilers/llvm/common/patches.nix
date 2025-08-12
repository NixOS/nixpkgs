{
  "clang/gnu-install-dirs.patch" = [
    {
      after = "19";
      path = ../19;
    }
  ];
  "clang/purity.patch" = [
    {
      after = "18";
      path = ../18;
    }
    {
      before = "17";
      path = ../16;
    }
  ];
  "clang/aarch64-tblgen.patch" = [
    {
      after = "17";
      before = "18";
      path = ../17;
    }
  ];
  "lld/add-table-base.patch" = [
    {
      path = ../16;
    }
  ];
  "lld/gnu-install-dirs.patch" = [
    {
      after = "18";
      path = ../18;
    }
  ];
  "llvm/gnu-install-dirs.patch" = [
    {
      after = "22";
      path = ../22;
    }
    {
      after = "21";
      before = "22";
      path = ../21;
    }
    {
      after = "20";
      before = "21";
      path = ../20;
    }
    {
      after = "18";
      before = "20";
      path = ../18;
    }
  ];
  "llvm/gnu-install-dirs-polly.patch" = [
    {
      after = "20";
      path = ../20;
    }
    {
      before = "20";
      after = "18";
      path = ../18;
    }
    {
      before = "18";
      path = ../16;
    }
  ];
  "llvm/llvm-lit-cfg-add-libs-to-dylib-path.patch" = [
    {
      before = "17";
      path = ../16;
    }
    {
      after = "17";
      path = ../17;
    }
  ];
  "llvm/lit-shell-script-runner-set-dyld-library-path.patch" = [
    {
      after = "18";
      path = ../18;
    }
    {
      before = "18";
      path = ../16;
    }
  ];
  "llvm/polly-lit-cfg-add-libs-to-dylib-path.patch" = [
    {
      path = ../16;
    }
  ];
  "libunwind/gnu-install-dirs.patch" = [
    {
      before = "17";
      path = ../16;
    }
  ];
  "compiler-rt/X86-support-extension.patch" = [
    {
      path = ../16;
    }
  ];
  "compiler-rt/armv6-scudo-libatomic.patch" = [
    {
      after = "19";
      path = ../19;
    }
    {
      before = "19";
      path = ../16;
    }
  ];
  "compiler-rt/gnu-install-dirs.patch" = [
    {
      before = "17";
      path = ../16;
    }
    {
      path = ../17;
    }
  ];
  "compiler-rt/darwin-targetconditionals.patch" = [
    {
      path = ../16;
    }
  ];
  "compiler-rt/normalize-var.patch" = [
    {
      path = ../16;
    }
  ];
  "openmp/fix-find-tool.patch" = [
    {
      after = "17";
      before = "19";
      path = ../17;
    }
  ];
  "openmp/run-lit-directly.patch" = [
    {
      path = ../16;
    }
  ];
  "libclc/use-default-paths.patch" = [
    {
      after = "19";
      before = "20";
      path = ../19;
    }
    {
      after = "20";
      path = ../20;
    }
  ];
  "libclc/gnu-install-dirs.patch" = [
    {
      before = "21";
      path = ../16;
    }
    {
      after = "21";
      path = ../21;
    }
  ];
}
