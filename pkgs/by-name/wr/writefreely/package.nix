{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "writefreely";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "writefreely";
    repo = "writefreely";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-sGCOFydegbD7m9OXNv3xsWFHy6kSZrIikGpci9y5nAw=";
  };

  vendorHash = "sha256-e9usNyJHwmRNMjovhuL7Z4Ll7f58DgA1v1/hfJTZ4pg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/writefreely/writefreely.softwareVer=${finalAttrs.version}"
  ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  passthru.tests = {
    inherit (nixosTests) writefreely;
  };

  meta = {
    description = "Build a digital writing community";
    homepage = "https://github.com/writefreely/writefreely";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ soopyc ];
    mainProgram = "writefreely";
  };
})
