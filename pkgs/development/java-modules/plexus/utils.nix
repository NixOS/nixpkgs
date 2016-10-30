{ fetchMaven }:

rec {
  plexusUtils_1_1 = map (obj: fetchMaven {
    version = "1.1";
    baseName = "plexus-utils";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "36k6grn4as4ka3diizwvybcfsn4spqqmqxvsaf66iq1zi2vxj3rsfr4xq6isv3p8f09wnnv9jm9xqqz4z0n3ah5mi8z1p5zhskcm5fs"; }
    { type = "pom"; sha512 = "0vbzdfsdcc4cq7hdqzb1vdfxp23vnavq7z4qmmlb4d4fiqj5wqdgagrs43gl7yzca2azpyj3kyxgaipimi7gck07jcsz0pzljkplk4w"; }
  ];

  plexusUtils_1_5_8 = map (obj: fetchMaven {
    version = "1.5.8";
    baseName = "plexus-utils";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0nx0l29lmphylkmnacwj6n1spdxxaqn1jr5vg4pcil9y2p08bzyn715bhwgazg3sa94ynzi38lsmf60y00prv3cy2zgj0smg5psq3z5"; }
    { type = "pom"; sha512 = "06z4gkq3bh2pwyj8pvaly9fihd8gbgcqp3jxl05vkj2rcdb4jw3lw3hwn8f8ggqi17i2fdm8cbndkqgr9vdgiz45p8f1nx8kjlqikbi"; }
  ];

  plexusUtils_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "plexus-utils";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3n0g1xhjkjm0m3ch5wm34vxvldw889p401rlwqrlzm6nh53h36plq955v2vv30gjdgp7n54lpr4pb374fxz6wbzj385kphmsgxbsaxc"; }
    { type = "pom"; sha512 = "22g2dlbgc557k126hd0nfaf6n76vwa19nnd0ga8ywdx5pnai63x9806d7dhvjm778rmgpxlrj65y8if36q0zkbg153i007cxg36indj"; }
  ];

  plexusUtils_3_0 = map (obj: fetchMaven {
    version = "3.0";
    baseName = "plexus-utils";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "16m1khf9fafb9f79rbz93qgc35d8605v1qbs4ywnj4sk00d00d6n1649cc9rv593r8ghwd0rkz345z7wb00fagdr9af5h8h5w5blsa1"; }
    { type = "pom"; sha512 = "123fsmm1jvy571yl1s3wp7yd5k52nfjqxzqpzx2940rsigm35rw2mx1g4bvr3wx0gv5bqlfmqj5cwdhhxdq5vzrax8z5vbmdg5vb77r"; }
  ];
}
