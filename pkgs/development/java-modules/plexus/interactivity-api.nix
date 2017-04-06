{ fetchMaven }:

rec {
  plexusInteractivityApi_1_0_alpha4 = map (obj: fetchMaven {
    version = "1.0-alpha-4";
    artifactId = "plexus-interactivity-api";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2zy33hz2g0mgb2ryjbgjrf55bmmglkbsmh03wx29d4cwgcd83i1wb211c1wxdnnf7a8cx6ryfhx1fxwq379m4793apa9aix8px5sqj2"; }
    { type = "pom"; sha512 = "27890lj546q9rapgzks8dkdc5d2lbsr1rgbhl9vxkr7hpqci0m2q6g7zpl94vk50hx4bb52p24j0x6dqsyd6ijnadbi1dysfnb6jm6f"; }
  ];
}
