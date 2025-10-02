{
  "clang/gnu-install-dirs.patch" = [
    {
      after = "19";
      path = ../19;
    }
  ];
  "clang/purity.patch" = [
    {
      path = ../18;
    }
  ];
  "lld/gnu-install-dirs.patch" = [
    {
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
      path = ../18;
    }
  ];
  "llvm/llvm-lit-cfg-add-libs-to-dylib-path.patch" = [
    {
      path = ../18;
    }
  ];
  "llvm/lit-shell-script-runner-set-dyld-library-path.patch" = [
    {
      path = ../18;
    }
  ];
  "llvm/polly-lit-cfg-add-libs-to-dylib-path.patch" = [
    {
      path = ../18;
    }
  ];
  "compiler-rt/X86-support-extension.patch" = [
    {
      path = ../18;
    }
  ];
  "compiler-rt/armv6-scudo-libatomic.patch" = [
    {
      after = "19";
      path = ../19;
    }
    {
      before = "19";
      path = ../18;
    }
  ];
  "compiler-rt/normalize-var.patch" = [
    {
      path = ../18;
    }
  ];
  "openmp/fix-find-tool.patch" = [
    {
      before = "19";
      path = ../18;
    }
  ];
  "openmp/run-lit-directly.patch" = [
    {
      path = ../18;
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
      path = ../18;
    }
    {
      after = "21";
      path = ../21;
    }
  ];
}
