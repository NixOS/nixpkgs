{
  pkgs,
}:
{
  timetagger = pkgs.testers.runNixOSTest {
    _class = "nixosTest";
    name = "timetagger-modular";
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
        environment.systemPackages = [ pkgs.curl ];
      };
    testScript = ''
      machine.wait_for_unit("default.target")
      machine.wait_for_unit("timetagger-plain.service")
      machine.wait_for_unit("timetagger-custom.service")
      machine.wait_for_unit("timetagger-port.service")
      machine.wait_for_open_port(8082)
      machine.wait_for_open_port(8083)
      machine.wait_for_open_port(8084)
      machine.succeed("curl -fsL http://localhost:8082 | grep -q 'TimeTagger'")
      machine.succeed("curl -fsL http://localhost:8083 | grep -q 'TimeTagger'")
      machine.succeed("curl -fsL http://localhost:8084 | grep -q 'TimeTagger'")
    '';
  };
}
