{ lib, fetchFromGitHub, stdenv, nodejs, pnpm, buildGoModule, mage, writeShellScriptBin, nixosTests }:

let
  version = "0.24.5";
  src = fetchFromGitHub {
    owner = "go-vikunja";
    repo = "vikunja";
    rev = "v${version}";
    hash = "sha256-P5H+NfjE8wTmPD1VOI72hPi2DlDb4pCyq0nphK1VGK0=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "vikunja-frontend";
    inherit version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src sourceRoot;
      hash = "sha256-D2dOyYsdsNV1ZSQdjpy6rfoix7yBACEHj/2XyHb7HWE=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    doCheck = true;

    postBuild = ''
      pnpm run build
    '';

    checkPhase = ''
      pnpm run test:unit --run
    '';

    installPhase = ''
      cp -r dist/ $out
    '';
  });

  # Injects a `t.Skip()` into a given test since there's apparently no other way to skip tests here.
  skipTest = lineOffset: testCase: file:
    let
      jumpAndAppend = lib.concatStringsSep ";" (lib.replicate (lineOffset - 1) "n" ++ [ "a" ]);
    in ''
      sed -i -e '/${testCase}/{
      ${jumpAndAppend} t.Skip();
      }' ${file}
    '';
in
buildGoModule {
  inherit src version;
  pname = "vikunja";

  nativeBuildInputs =
    let
      fakeGit = writeShellScriptBin "git" ''
        if [[ $@ = "describe --tags --always --abbrev=10" ]]; then
            echo "${version}"
        else
            >&2 echo "Unknown command: $@"
            exit 1
        fi
      '';
    in
    [ fakeGit mage ];

  vendorHash = "sha256-OsKejno8QGg7HzRsrftngiWGiWHFc1jDLi5mQ9/NjI4=";

  inherit frontend;

  prePatch = ''
    cp -r ${frontend} frontend/dist
  '';

  postConfigure = ''
    # These tests need internet, so we skip them.
    ${skipTest 1 "TestConvertTrelloToVikunja" "pkg/modules/migration/trello/trello_test.go"}
    ${skipTest 1 "TestConvertTodoistToVikunja" "pkg/modules/migration/todoist/todoist_test.go"}
  '';

  buildPhase = ''
    runHook preBuild

    # Fixes "mkdir /homeless-shelter: permission denied" - "Error: error compiling magefiles" during build
    export HOME=$(mktemp -d)
    mage build:build

    runHook postBuild
  '';

  checkPhase = ''
    mage test:unit
    mage test:integration
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin vikunja
    runHook postInstall
  '';

  passthru.tests.vikunja = nixosTests.vikunja;

  meta = {
    changelog = "https://kolaente.dev/vikunja/api/src/tag/v${version}/CHANGELOG.md";
    description = "Todo-app to organize your life";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ leona ];
    mainProgram = "vikunja";
    platforms = lib.platforms.linux;
  };
}
