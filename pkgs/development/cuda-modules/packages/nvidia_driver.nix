{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "nvidia_driver";

  outputs = [ "out" ];

  brokenAssertions = [
    {
      message = "use drivers from linuxPackages";
      assertion = false;
    }
  ];
}
