{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "driver_assistant";

  outputs = [ "out" ];

  platformAssertions = [
    {
      message = "Package is not supported; use drivers from linuxPackages";
      assertion = false;
    }
  ];
}
