{
  lib,
  stdenv,
  fetchFromGitHub,
  libuv,
  nix-update-script,
  pkg-config,
  python3,
  testers,
  wren,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wren-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "wren-lang";
    repo = "wren-cli";
    rev = finalAttrs.version;
    hash = "sha256-AUb17rV07r00SpcXAOb9PY8Ea2nxtgdZzHZdzfX5pOA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libuv
    wren
  ];

  nativeCheckInputs = [
    python3
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  postPatch = ''
    # `libuv`'s headers pull in `unistd.h` on Unix-like platforms, which
    # declares write(2). Since this file is compiled as C, having a different
    # `static void write(...)` causes a hard error ("conflicting types for 'write'").
    substituteInPlace src/cli/vm.c \
      --replace-fail "static void write(WrenVM* vm, const char* text)" "static void writeToStdout(WrenVM* vm, const char* text)" \
      --replace-fail "config.writeFn = write;" "config.writeFn = writeToStdout;"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-D_GNU_SOURCE";

  buildPhase = ''
    runHook preBuild

    mkdir -p build bin

    for src in src/cli/*.c src/module/*.c; do
      $CC \
        -std=c99 \
        -Isrc/cli \
        -Isrc/module \
        $($PKG_CONFIG --cflags libuv) \
        -c "$src" \
        -o "build/$(basename "''${src%.c}.o")"
    done

    $CC -o bin/wren_cli build/*.o \
      $($PKG_CONFIG --libs libuv) \
      -lwren \
      -lm

    runHook postBuild
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    python3 util/test.py

    cat > hello.wren <<'EOF'
    System.print("Hello, world!")

    class Wren {
      flyTo(city) {
        System.print("Flying to %(city)")
      }
    }

    var adjectives = Fiber.new {
      ["small", "clean", "fast"].each {|word| Fiber.yield(word) }
    }

    while (!adjectives.isDone) System.print(adjectives.call())
    EOF

    ./bin/wren_cli hello.wren > actual
    grep -Fx "Hello, world!" actual
    grep -Fx "small" actual
    grep -Fx "clean" actual
    grep -Fx "fast" actual

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/wren_cli -t "$out/bin"
    ln -s wren_cli "$out/bin/wren"

    runHook postInstall
  '';

  meta = {
    description = "CLI and REPL tool for running Wren scripts";
    homepage = "https://wren.io/cli/";
    changelog = "https://github.com/wren-lang/wren-cli/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "wren_cli";
    maintainers = with lib.maintainers; [ Zaczero ];
    platforms = lib.platforms.unix;
  };
})
