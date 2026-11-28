{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "termsvg";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "MrMarble";
    repo = "termsvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9IWSjOQBYKRaHL9YptjponIBegA84BrUgne/iH8Yl30=";
  };

  vendorHash = "sha256-CYyxhof8Rxmpp2mL+853iKm7z05dXu8mcjygnQqHQz8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  checkFlags =
    let
      skippedTests = [
        # fatal: not a git repository: .git
        "TestSVGLayoutMatrixCapturesNineVariantsAtTwoFrameRates"

        # writes and execute shell scripts that lack patchShebang
        "TestUpdateFilesizeUsesConventionalReduction"
        "TestUpdateFilesizeCountsOnlyTheCheckedOutHistory"
        "TestUpdateFilesizeRefusesAShallowClone"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Record, share and export your terminal as a animated SVG image";
    homepage = "https://github.com/MrMarble/termsvg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "termsvg";
  };
})
