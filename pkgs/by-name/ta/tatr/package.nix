{
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  runCommand,
  lib,
}:

let
  smallHash = revision: builtins.substring 0 12 revision;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tatr";
  version = "0-unstable-2026-10-18";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "tatr";
    rev = "1ae92066dad5634412efde4bef87967017209273";
    hash = "sha256-Xvj8mgRhA20achPYUumLTPYq8yYwXJqJ864zvWmJNTE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace nob.c \
      --replace-fail 'if (!cmd_run(&cmd, .stdout_path = BUILD_FOLDER"git_status.txt")) {' \
                     'cmd = (Cmd){0}; if (false) {'
    substituteInPlace nob.c \
      --replace-fail 'if (!cmd_run(&cmd, .stdout_path = BUILD_FOLDER"git_hash.txt")) {' \
                     'cmd = (Cmd){0}; if (false) {'
  '';

  buildPhase = ''
    runHook preBuild

    mkdir build
    echo "" > build/git_status.txt
    echo "${smallHash finalAttrs.src.rev}" > build/git_hash.txt

    cc -o nob nob.c
    ./nob -test # This command builds executable first and then runs tests

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ./build/tatr $out/bin/tatr

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  preVersionCheck = ''
    export version="${smallHash finalAttrs.src.rev}"
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

    tests = {
      simple-test = runCommand "tatr-simple-test" { nativeBuildInputs = [ finalAttrs.finalPackage ]; } ''
        tatr init
        if [[ ! -f ./tasks/README.md ]]; then
          echo "./tasks/README.md doesn't exist"
          exit 1
        fi

        tatr new Foo
        grep -q -E "^# Foo$" ./tasks/*/TASK.md \
          || (echo "Could not find title Foo in TASK.md file" >&2 && exit 2)

        sleep 1 # Needed to make sure next task will have a different ID
        tatr new Bar
        tatr ls > tatr-ls-output.txt
        grep -q -E "TASK\.md:1: OPEN \[PRIORITY: 100\] Foo$" tatr-ls-output.txt \
          || (echo "Could not find Foo task in \`tatr ls\` output" >&2 && exit 3)
        grep -q -E "TASK\.md:1: OPEN \[PRIORITY: 100\] Bar$" tatr-ls-output.txt \
          || (echo "Could not find Bar task in \`tatr ls\` output" >&2 && exit 4)

        touch $out
      '';
    };
  };

  meta = {
    homepage = "https://github.com/tsoding/tatr";
    description = "Command line task tracker";
    mainProgram = "tatr";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
  };
})
