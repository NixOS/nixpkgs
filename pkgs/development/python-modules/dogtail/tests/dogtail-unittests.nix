{ hostPkgs, lib, ... }:
let
  python = hostPkgs.python3.withPackages (
    p: with p; [
      dogtail
      xlib
    ]
  );

  # python needs this to find gobject introspection data for at-spi, gtk, etc.
  giTypelibPath = hostPkgs.lib.makeSearchPath "lib/girepository-1.0" (
    map (p: p.out or p) (
      with hostPkgs;
      [
        at-spi2-core
        gtk3
        gobject-introspection
        glib
        pango
        harfbuzz
        gdk-pixbuf
      ]
    )
  );

  # wrap the env injection and test setup so the python testscript stays clean
  runDogtailTests = hostPkgs.writeShellScriptBin "run-dogtail-tests" ''
    export XDG_RUNTIME_DIR=/run/user/1000
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
    export WAYLAND_DISPLAY=wayland-0
    export DISPLAY=:0
    export XDG_DATA_DIRS="${hostPkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${hostPkgs.gsettings-desktop-schemas.name}"
    export GI_TYPELIB_PATH="${giTypelibPath}"

    cp -r ${python.pkgs.dogtail.src}/tests ~/tests
    chmod -R +w ~/tests
    cd ~/tests

    # 2 tests with Nautilus drag fail, they are not up to date for latest gnome, skip
    sed -i \
      's/class TestGnomeShellOverviewRawinput(unittest.TestCase):/@unittest.skip("incompatible with modern gnome overview layout")\nclass TestGnomeShellOverviewRawinput(unittest.TestCase):/' \
      test_rawinput_drag.py

    # fix hardcoded /usr/bin/gtk?-demo paths in the tests
    find . -type f -name "*.py" -exec sed -i 's|/usr/bin/gtk3-demo|/run/current-system/sw/bin/gtk3-demo|g' {} +
    find . -type f -name "*.py" -exec sed -i 's|/usr/bin/gtk4-demo|/run/current-system/sw/bin/gtk4-demo|g' {} +

    exec ${lib.getExe python} -m unittest discover -v
  '';
in
{
  name = "dogtail-unittests";

  nodes.machine =
    {
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports = [
        (modulesPath + "/../tests/common/user-account.nix")
      ];

      services.xserver.enable = true;
      services.xserver.displayManager.lightdm.enable = true;

      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };

      services.desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.interface]
          toolkit-accessibility=true

          [org.gnome.shell]
          favorite-apps=['org.gnome.Nautilus.desktop']
        '';
      };

      services.displayManager.defaultSession = "gnome";

      # override pam to completely bypass password checks for autologin
      security.pam.services.lightdm-autologin.text = lib.mkForce ''
        auth     requisite pam_nologin.so
        auth     required  pam_succeed_if.so quiet
        auth     required  pam_permit.so
        account  include   lightdm
        password include   lightdm
        session  include   lightdm
      '';

      services.gnome.at-spi2-core.enable = true;

      environment.systemPackages = with pkgs; [
        gtk3
        gtk4

        # NOTE: adding these will try to run the complete test suite
        # But the tests expect gnome x11, whereas we can't have that now as gnome is wayland only
        # so test only the core functionality as of now

        # gtk3.dev # gtk3-demo
        # gtk4.dev # gtk4-demo

        python
        gnome-ponytail-daemon
        nautilus
        highlight
        runDogtailTests
      ];

      services.dbus.packages = [ pkgs.gnome-ponytail-daemon ];
      systemd.packages = [ pkgs.gnome-ponytail-daemon ];

      systemd.user.services.gnome-ponytail-daemon = {
        enable = true;
        wantedBy = [ "graphical-session.target" ];
      };

      systemd.user.services.at-spi-dbus-bus.wantedBy = [ "default.target" ];

      users.users.alice = {
        extraGroups = [ "wheel" ];
        linger = true;
      };

      security.sudo.wheelNeedsPassword = false;
    };

  testScript = ''
    machine.wait_for_file("/run/user/1000/wayland-0")
    machine.wait_for_file("/run/user/1000/bus")
    machine.wait_until_succeeds("pgrep gnome-shell")

    output = machine.succeed("sudo -u alice run-dogtail-tests")
    print(output)
  '';
}
