{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "tcardgen";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Ladicle";
    repo = "tcardgen";
    tag = "v${version}";
    sha256 = "sha256-TojNst+KUbCEHf0Vbg3TyRy4F6jHidjmPL56gzL0Y1U=";
  };

  patches = [
    ./0001-test-fix-expected-error-string-in-test-for-hugo-pack.patch
  ];

  vendorHash = "sha256-X39L1jDlgdwMALzsVIUBocqxvamrb+M5FZkDCkI5XCc=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "TwitterCard(OGP) image generator for Hugo posts.";
    homepage = "https://github.com/Ladicle/tcardgen";
    license = lib.licenses.mit;
    mainProgram = "tcardgen";
    maintainers = with lib.maintainers; [ nanamiiiii ];
    platforms = lib.platforms.all;
  };
}
