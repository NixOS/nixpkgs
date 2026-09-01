{
  lib,
  callPackage,
  fetchFromGitHub,
  buildGo127Module,
  mage,
  writeShellScriptBin,
  nixosTests,
  nix-update-script,
}:

let
  buildGoModule = buildGo127Module;

  # Injects a `t.Skip()` into a given test since there's apparently no other way to skip tests here.
  skipTest =
    lineOffset: testCase: file:
    let
      jumpAndAppend = lib.concatStringsSep ";" (lib.replicate (lineOffset - 1) "n" ++ [ "a" ]);
    in
    ''
      sed -i -e '/${testCase}/{
      ${jumpAndAppend} t.Skip();
      }' ${file}
    '';
in
buildGoModule (finalAttrs: {
  pname = "vikunja";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "vikunja";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Xh1ozUTOVqywk0i8xQWkG/bPRgPH9EABjRW8p4do1mE=";
  };

  nativeBuildInputs =
    let
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "describe --tags --always --abbrev=10" ]]; then
            echo "${finalAttrs.version}"
        else
            >&2 echo "Unknown command: $@"
            exit 1
        fi
      '';
    in
    [
      fakeGit
      mage
    ];

  vendorHash = "sha256-R6M5UyF10pIdoAvjWnS6Dqe/U6LTxmS6OwRTgmxfU4g=";

  frontend = callPackage ./frontend.nix {
    inherit (finalAttrs) src version;
  };

  veans = callPackage ./veans.nix {
    inherit (finalAttrs) src version meta;
    inherit buildGoModule;
  };

  prePatch = ''
    cp -r ${finalAttrs.frontend} frontend/dist
  '';

  postConfigure = ''
    # These tests need internet, so we skip them.
    ${skipTest 1 "TestConvertTrelloToVikunja" "pkg/modules/migration/trello/trello_test.go"}
    ${skipTest 1 "TestConvertTodoistToVikunja" "pkg/modules/migration/todoist/todoist_test.go"}
    # These tests require a full config with public URL and CORS enabled.
    ${skipTest 1 "TestCreateOrganizationMap" "pkg/modules/migration/trello/trello_test.go"}
    ${skipTest 1 "TestTaskAttachmentUploadSize" "pkg/webtests/task_attachment_upload_test.go"}
  '';

  buildPhase = ''
    runHook preBuild

    # Fixes "mkdir /homeless-shelter: permission denied" - "Error: error compiling magefiles" during build
    export HOME=$(mktemp -d)
    mage build:build

    runHook postBuild
  '';

  checkPhase = ''
    mage test:feature
    mage test:web
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin vikunja
    runHook postInstall
  '';

  passthru = {
    # used by vikuna-desktop
    inherit (finalAttrs) frontend;

    tests.vikunja = nixosTests.vikunja;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
        "--subpackage"
        "veans"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/go-vikunja/vikunja/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Todo-app to organize your life";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      leona
      adamcstephens
    ];
    mainProgram = "vikunja";
    platforms = lib.platforms.linux;
  };
})
