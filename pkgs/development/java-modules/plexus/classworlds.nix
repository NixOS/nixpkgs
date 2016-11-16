{ fetchMaven }:

rec {
  plexusClassworlds_2_2_2 = map (obj: fetchMaven {
    version = "2.2.2";
    artifactId = "plexus-classworlds";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0w6mhv2xjafqr45zx5fwm8iyp8kabrdvyx91qxwy04k71ah6zxzqx1l8ppq7xma4r40lpp98valr1ydgfm1cay87j1kbdgaw2j48vns"; }
    { type = "pom"; sha512 = "12kxa236gg61gs6cshgwnsj0yfpywcb606j10l9hflp951vxvlcwpcdh1nlpir0zyqj7rnk5g8609grwahq2m62fs1ymqp8db2rqi56"; }
  ];

  plexusClassworlds_2_4 = map (obj: fetchMaven {
    version = "2.4";
    artifactId = "plexus-classworlds";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1299qgrf60pz9a40wccb1376wibk99rf79x8dw9z2c97gyzxb3narkpna3fk9wqs7a89p18d2b7zi7vxr3wcdhw6n8saxggz44w9gpq"; }
    { type = "pom"; sha512 = "1g2xisql030wjb8kvrfp0qcip2b4jbf4islmxa0k1fvjyrzms5babgdpx7m75g29dl8s649z8fb90wrrqc7g14y9g74lydc9i6rd2q5"; }
  ];
}
