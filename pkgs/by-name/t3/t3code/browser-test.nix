{
  browser,
  lib,
  t3code,
  testers,
  writeShellScript,
}:
let
  staleBrowser = writeShellScript "stale-t3code-browser" ''
    touch /tmp/stale-browser-executed
    echo 'error while loading shared libraries: libstale-browser.so' >&2
    exit 127
  '';
in
testers.runNixOSTest {
  name = "t3code-browser";
  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ t3code ];
      users.users.browser.isNormalUser = true;
      fonts.fontconfig.enable = true;
      fonts.packages = [ pkgs.dejavu_fonts ];
    };
  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("setup recognizes the browser with an empty cache"):
        output = machine.succeed("runuser -u browser -- t3 browser setup")
        assert "This host is ready for T3's browser." in output

    with subtest("setup ignores stale downloaded browsers"):
        machine.succeed(
            "install -D -m755 ${staleBrowser} "
            "/home/browser/.t3/tools/chrome-headless-shell/linux64/old/chrome-headless-shell"
        )
        output = machine.succeed("runuser -u browser -- t3 browser setup")
        assert "This host is ready for T3's browser." in output
        machine.fail("test -e /tmp/stale-browser-executed")

    with subtest("the browser renders with its sandbox enabled"):
        output = machine.succeed(
            "runuser -u browser -- timeout 30s ${lib.getExe browser} "
            "--headless=new --disable-gpu --screenshot=/tmp/browser.png --dump-dom "
            "'data:text/html,<h1>t3code-browser-ok</h1>'"
        )
        assert "t3code-browser-ok" in output
        machine.succeed("test -s /tmp/browser.png")
  '';
}
