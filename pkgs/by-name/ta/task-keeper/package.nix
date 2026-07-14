{
  lib,
  rustPlatform,
  fetchFromGitHub,
  just,
  openssl,
  pkg-config,
  runCommand,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "task-keeper";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pSMF0ORwHUV9H6RAMRaEt/A61MVIj5cQcsY+wDDyAwk=";
  };

  patches = [
    # https://github.com/linux-china/task-keeper/pull/20
    ./version.patch
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-leQpeB145seO2mPg+eqA3S5ATbRBzsXj9cWNsVpXF+U=";

  # tests depend on many packages (java, node, python, sbt, ...) - which I'm not currently willing to set up 😅
  doCheck = false;

  passthru = {
    tests = {
      makefile =
        runCommand "task-keeper-makefile-test"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            printf "nix-test-task:\n\techo 2047" > Makefile
            tk > output.txt
            grep -qF -- "make: Makefile" output.txt
            grep -qF -- "-- nix-test-task" output.txt
            tk nix-test-task > output.txt
            grep -qF -- "[tk] execute nix-test-task from make" output.txt
            grep -qF -- "echo 2047" output.txt
            touch $out
          '';
      justfile =
        runCommand "task-keeper-justfile-test"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              just
            ];
          }
          ''
            printf "nix-test-just-task:\n\techo 4095" > Justfile
            tk > output.txt
            grep -qF -- "just: Justfile" output.txt
            grep -qF -- "-- nix-test-just-task" output.txt
            tk nix-test-just-task > stdout.txt 2> stderr.txt
            grep -qF -- "[tk] execute nix-test-just-task from just" stdout.txt
            grep -qF -- "echo 4095" stderr.txt
            touch $out
          '';
    };
  };

  meta = {
    homepage = "https://github.com/linux-china/task-keeper";
    description = "CLI to manage tasks from different task runners or package managers";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tennox
      DimitarNestorov
    ];
    mainProgram = "tk";
  };
})
