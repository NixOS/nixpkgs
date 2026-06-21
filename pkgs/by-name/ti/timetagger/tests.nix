{
  pkgs,
}:
{
  timetagger = pkgs.testers.runNixOSTest {
    # hostPkgs ??
    _class = "nixosTest";

    name = "timetagger";

    nodes.machine =
      { pkgs, lib, ... }:
      {
        system.services.timetagger-plain = pkgs.timetagger.services.default;
        system.services.timetagger-custom = {
          imports = [ pkgs.timetagger.services.default ];
          timetagger.package = pkgs.timetagger.override { port = 8083; };
        };
        system.services.timetagger-port = {
          imports = [ pkgs.timetagger.services.default ];
          timetagger.port = 8084;
        };
      };

    testScript = ''
      machine.wait_for_unit("default.target")
      machine.wait_for_unit("timetagger-plain.service")
      machine.wait_for_unit("timetagger-custom.service")
      machine.wait_for_unit("timetagger-port.service")
      machine.wait_for_open_port(8082)
      machine.wait_for_open_port(8083)
      machine.wait_for_open_port(8084)
    '';
  };
}
