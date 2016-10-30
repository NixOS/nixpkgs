{ fetchMaven }:

rec {
  plexusContainerDefault_1_0_alpha9_stable1 = map (obj: fetchMaven {
    version = "1.0-alpha-9-stable-1";
    baseName = "plexus-container-default";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1dpzdijx7xb3kgv2ybias3shzvpsq82w6x1ig5gdkg0i47m6a1ld53bi3gjczdpn88xparp80jkqlacjb65764v05ps6zg0v3vr1dkw"; }
    { type = "pom"; sha512 = "1gnm9ivwrkr3aqpnmdl34hkx53189wxj9acp2fms8inhznrxqcyyk355gpgzwvs9qpgdis1q88mj1fy3x1v3ffa3b6wi758p95q79jc"; }
  ];
}
