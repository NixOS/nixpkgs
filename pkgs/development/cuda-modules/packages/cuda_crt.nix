{ backendStdenv, buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_crt";

  outputs = [ "out" ];

  brokenAssertions = [
    # TODO(@connorbaker): Build fails on x86 when using pkgsLLVM.
    #  .../include/crt/host_defines.h:67:2:
    #  error: "libc++ is not supported on x86 system"
    #
    #     67 | #error "libc++ is not supported on x86 system"
    #        |  ^
    #
    #  1 error generated.
    #
    #  # --error 0x1 --
    {
      message = "cannot use libc++ on x86_64-linux";
      assertion = backendStdenv.hostNixSystem == "x86_64-linux" -> backendStdenv.cc.libcxx == null;
    }
  ];

  # There's a comment with a reference to /usr
  allowFHSReferences = true;
}
