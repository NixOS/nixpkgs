{
  lib,
  xvfb-run,
  zoom-us,
  runCommand,
  writeShellApplication,
  xorg,
}:

let
  testScript = writeShellApplication {
    name = "zoom-us-test-script";
    runtimeInputs = [
      xorg.xwininfo
      zoom-us
    ];
    text = ''
      function is_zoom_window_present {
        echo
        xwininfo -root -tree  \
            | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'  \
            | tee window-names
        grep -q "Zoom Workplace" window-names
      }
      # Don't let zoom eat all RAM, like it did, cf.
      # https://github.com/NixOS/nixpkgs/issues/371488
      prlimit --{as,data}=$((4*2**30)):$((4*2**30)) zoom-us &
      for _ in {0..900} ; do
        if is_zoom_window_present ; then
          break
        fi
        sleep 1
      done
      # If libraries are missing, the window still appears,
      # but then disappears again immediately; check for that also.
      sleep 20
      is_zoom_window_present
    '';
  };
in
runCommand "zoom-us-test" { buildInputs = [ xvfb-run ]; } ''
  HOME=$PWD xvfb-run ${lib.getExe testScript}
  touch ${placeholder "out"}
''
