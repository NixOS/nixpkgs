{ fetchMaven }:

rec {
  plexusClassworlds_2_2_2 = map (obj: fetchMaven {
    version = "2.2.2";
    baseName = "plexus-classworlds";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0w6mhv2xjafqr45zx5fwm8iyp8kabrdvyx91qxwy04k71ah6zxzqx1l8ppq7xma4r40lpp98valr1ydgfm1cay87j1kbdgaw2j48vns"; }
    { type = "pom"; sha512 = "12kxa236gg61gs6cshgwnsj0yfpywcb606j10l9hflp951vxvlcwpcdh1nlpir0zyqj7rnk5g8609grwahq2m62fs1ymqp8db2rqi56"; }
  ];
}
