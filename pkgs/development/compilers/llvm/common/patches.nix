{
  "clang/gnu-install-dirs.patch" = [
    {
      before = "14";
      path = ../12;
    }
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
      after = "15";
      path = ../15;
    }
    {
      before = "16";
      path = ../12;
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
      after = "16";
      path = ../16;
    }
  ];
  "lld/gnu-install-dirs.patch" = [
    {
      after = "18";
      path = ../18;
    }
    {
      before = "14";
      path = ../12;
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
      after = "14";
      path = ../14;
    }
  ];
  "llvm/llvm-lit-cfg-add-libs-to-dylib-path.patch" = [
    {
      before = "17";
      after = "15";
      path = ../15;
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
      after = "16";
      before = "18";
      path = ../16;
    }
  ];
  "llvm/polly-lit-cfg-add-libs-to-dylib-path.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
  "libunwind/gnu-install-dirs.patch" = [
    {
      before = "17";
      after = "15";
      path = ../15;
    }
  ];
  "compiler-rt/X86-support-extension.patch" = [
    {
      after = "15";
      path = ../15;
    }
    {
      before = "15";
      path = ../12;
    }
  ];
  "compiler-rt/armv6-scudo-libatomic.patch" = [
    {
      after = "19";
      path = ../19;
    }
    {
      after = "15";
      before = "19";
      path = ../15;
    }
    {
      before = "15";
      path = ../14;
    }
  ];
  "compiler-rt/armv7l.patch" = [
    {
      before = "15";
      after = "13";
      path = ../13;
    }
  ];
  "compiler-rt/gnu-install-dirs.patch" = [
    {
      before = "14";
      path = ../12;
    }
    {
      after = "13";
      before = "15";
      path = ../14;
    }
    {
      after = "15";
      before = "17";
      path = ../15;
    }
    {
      after = "16";
      path = ../17;
    }
  ];
  "compiler-rt/darwin-targetconditionals.patch" = [
    {
      after = "13";
      path = ../13;
    }
  ];
  "compiler-rt/codesign.patch" = [
    {
      after = "13";
      path = ../13;
    }
  ];
  "compiler-rt/normalize-var.patch" = [
    {
      after = "16";
      path = ../16;
    }
    {
      before = "16";
      path = ../12;
    }
  ];
  "lldb/procfs.patch" = [
    {
      after = "15";
      path = ../15;
    }
    {
      before = "15";
      path = ../12;
    }
  ];
  "lldb/resource-dir.patch" = [
    {
      before = "16";
      path = ../12;
    }
  ];
  "llvm/no-pipes.patch" = [
    {
      before = "16";
      path = ../12;
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
      after = "16";
      path = ../16;
    }
    {
      after = "14";
      before = "16";
      path = ../14;
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
      after = "16";
      before = "21";
      path = ../16;
    }
    {
      after = "21";
      path = ../21;
    }
  ];
}
