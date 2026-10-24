{
  lib,
  runCommand,
  bash,
  coreutils,
  python3,
  t3code,
}:

{
  pty = runCommand "t3code-desktop-pty-smoke" { } ''
    export HOME="$TMPDIR"
    export T3CODE_HOME="$HOME/.t3"
    ${coreutils}/bin/timeout 60s env ELECTRON_RUN_AS_NODE=1 \
      ${lib.getExe t3code.unwrapped.electron} -e '
        const assert = require("node:assert/strict");
        const pty = require("${t3code.unwrapped}/libexec/t3code/apps/server/node_modules/node-pty");
        const deadline = setTimeout(() => { throw new Error("PTY did not exit"); }, 30000);
        const terminal = pty.spawn("${lib.getExe bash}", [
          "--noprofile", "--norc", "-c", "printf pty-ok",
        ], { env: process.env });
        let output = "";
        terminal.onData((data) => { output += data; });
        terminal.onExit(({ exitCode }) => {
          clearTimeout(deadline);
          assert.equal(exitCode, 0);
          assert.equal(output, "pty-ok");
        });
      '
    touch "$out"
  '';

  web =
    runCommand "t3code-web-startup-smoke"
      {
        T3CODE_TELEMETRY_ENABLED = "false";
        __darwinAllowLocalNetworking = true;
      }
      ''
        export HOME="$TMPDIR"
        export T3CODE_HOME="$HOME/.t3"
        ${python3}/bin/python ${./web-smoke.py} ${t3code}/bin/t3
        touch "$out"
      '';
}
