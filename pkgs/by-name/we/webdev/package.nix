{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  versionCheckHook,
  callPackage,
  testers,
  yq-go,
}:
buildDartApplication (finalAttrs: {
  pname = "webdev";
  version = "3.8.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dart-lang";
    repo = "webdev";
    tag = "webdev-v${finalAttrs.version}";
    hash = "sha256-IwH0+J0iCSPxP/FbKPtmhpWjE16SGyYK88xa8ioBC2w=";
  };

  sourceRoot = "${finalAttrs.src.name}/webdev";

  dartEntryPoints = {
    "bin/webdev" = "bin/webdev.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ yq-go ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  # Remove the dev_dependencies section.
  # Relative path overrides in the monorepo break the Nix build which expects
  # all dependencies to be resolved via the lockfile.
  preBuild = ''
    yq -i 'del(.dev_dependencies)' pubspec.yaml
  '';

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });

    tests = {
      # Basic usage check
      usage = testers.runCommand {
        name = "webdev-usage-test";
        # Reference the package itself via finalPackage
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          export HOME=$TMPDIR
          webdev --help > output.txt
          if grep -q "Usage: webdev" output.txt; then
            echo "Usage check passed ✅"
            touch $out
          else
            echo "Usage check failed ❌"
            exit 1
          fi
        '';
      };
    };
  };

  meta = {
    mainProgram = "webdev";
    homepage = "https://dart.dev/tools/webdev";
    description = "Command-line tool for developing and deploying web applications with Dart";
    longDescription = ''
      A CLI for Dart web development. Provides an easy and consistent set of features for users and tools to build and deploy web applications with Dart.
    '';
    changelog = "https://pub.dev/packages/webdev/changelog#${
      lib.replaceString "." "" finalAttrs.version
    }";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers.cpeParts =
      let
        versionSplit = lib.split "\\+" finalAttrs.version;
        versionPart = lib.elemAt versionSplit 0;
        updatePart =
          if lib.count (x: lib.isList x) versionSplit > 0 then lib.elemAt versionSplit 2 else "*";
      in
      {
        vendor = "dart-lang";
        product = "webdev";
        version = versionPart;
        update = updatePart;
      };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
