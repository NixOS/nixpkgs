{ fetchMaven }:

rec {
  plexusUtils_1_0_4 = map (obj: fetchMaven {
    version = "1.0.4";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3bk54p57k27fy0gdqbagscp0qqhpb116ds8jw9vcqncl3x31xs1fp0d59pjylc62h9r9g4jp068v0b116n00ljrfjfsnvnknnnlahmd"; }
    { type = "pom"; sha512 = "35mm9fkfw1wljabr4lz6l5mq3mxgl7k87whlcz5qlddsbxy0j69j4xgf1fvjlyp06nqq2wz574v54aqpxgp8s6jwjyz9wyvqvsyka8d"; }
  ];

  plexusUtils_1_0_5 = map (obj: fetchMaven {
    version = "1.0.5";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2wj0xyywifivqq1rnmd3lj7c4kgprcyq3rb4v4y5rr89isdm40hnfhziz0zakyysk8wqw4l4wp3lg7vxhs3yd44rdfm0czvkjl726zj"; }
    { type = "pom"; sha512 = "1pz98avnr6pml058mg2db79rpxckcxkgpl8z373l055kppsy1pvmkhjahkjpzfrg63pdsk2kgm2ls9ji5697whpbm7xcwi8j3ssx791"; }
  ];

  plexusUtils_1_1 = map (obj: fetchMaven {
    version = "1.1";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "36k6grn4as4ka3diizwvybcfsn4spqqmqxvsaf66iq1zi2vxj3rsfr4xq6isv3p8f09wnnv9jm9xqqz4z0n3ah5mi8z1p5zhskcm5fs"; }
    { type = "pom"; sha512 = "0vbzdfsdcc4cq7hdqzb1vdfxp23vnavq7z4qmmlb4d4fiqj5wqdgagrs43gl7yzca2azpyj3kyxgaipimi7gck07jcsz0pzljkplk4w"; }
  ];

  plexusUtils_1_4_1 = map (obj: fetchMaven {
    version = "1.4.1";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "33b5mg4y3a57dfh41v2wimmvc9fqqh8dhihyd1hqg0lif40nnfc7yhypj1lr2ik95vd1vn6jghv0fi4pkzkbr7vb463gl6kz4yra2fk"; }
    { type = "pom"; sha512 = "00h4r4l6isrks402minrpmm0shx8mxhkc31dbfcm86r220vl0bbgxw9mfqqc2ldjh7wkwcd0xp236kxwphxcrajiayxgvp7xgqnvfvb"; }
  ];

  plexusUtils_1_4_5 = map (obj: fetchMaven {
    version = "1.4.5";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1f20xhp8jnkc70fy6b0fbhb16pvbwp83k4dwwar4r5570yn24j09iqlk8bhz6ra8pnkh0jz0idg61wrlz9mghzbmgdn6f2dj25dzr8s"; }
    { type = "pom"; sha512 = "0liqhpc9pn81vn04qz4j3101jc33hygb415jnwpf0dhph3jay88l49gd9s1bwq6x4npn2v6863vidb8hdh5f8wd20k6m1lqhdpv882j"; }
  ];

  plexusUtils_1_4_9 = map (obj: fetchMaven {
    version = "1.4.9";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "12fhq89mqj8m5y0ks8h39ig2q4nr3qlygjwygp9wg60dkfqrm6rscfrycs18pqd9y9fkhk8rqi96gq2vy8wg1v1a24h2wlzak1d22ip"; }
    { type = "pom"; sha512 = "23fpn9f8gq0a3hi2mlwzjpbr3kyrsr4wl58zyq8i6xbdnnfx0wfwc2xsfn8yp3mq2pjjpdlza9l3qdmwsyzmrz8micvms8bladpvcmv"; }
  ];

  plexusUtils_1_5_1 = map (obj: fetchMaven {
    version = "1.5.1";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "00vf59sg0wa4kip1m365xh3ngggvnr7avkf1mwsljyag5h8pb4fhpba550ka2mbpp10z8d7mjhj3wxinvf19m2bmrjmqvdxiwraa5jh"; }
    { type = "pom"; sha512 = "161cdrgjrw2cab4lf189hwa4s1lh42fsahjcjkir696sx0m9bmmxgjbhwxl1l8kpaxn5p6jf701bx16gry393pws636vy59nvnnx1sw"; }
  ];

  plexusUtils_1_5_5 = map (obj: fetchMaven {
    version = "1.5.5";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1ygv6mcv07kb0z8hrg98xg0sr0qqyf1v3snki6j3pn8wwn5bl46j8l70c7bpcv2jf623jn7g8gbkvjl9m04v23v3jlcc106cicbgx3v"; }
    { type = "pom"; sha512 = "29knasqhkvjif27gm3ycqhc206ycgc9920mccw7biybxmiqqajyfvv74f02sqpavlk5h6l45cfb20bmldwfznvzz9bw4zhvc12s9y5h"; }
  ];

  plexusUtils_1_5_6 = map (obj: fetchMaven {
    version = "1.5.6";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "26p385szy6sphplalxc9750f29z7fnvmaz7m1fv0mx7p7qmvkk6pm5m4kl636m8jsflkfmzh4f4y5vj5vhxypfyc4pdzfsp9xyc3vwq"; }
    { type = "pom"; sha512 = "261yv9sgjmslxjsfx7fj1ma53ld930qxic4br5m88wv96skyni09w2nh9sslgrmpxj3q89ykhq3fciscn40066v1qn0h0f6lbk3w68r"; }
  ];

  plexusUtils_1_5_8 = map (obj: fetchMaven {
    version = "1.5.8";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0nx0l29lmphylkmnacwj6n1spdxxaqn1jr5vg4pcil9y2p08bzyn715bhwgazg3sa94ynzi38lsmf60y00prv3cy2zgj0smg5psq3z5"; }
    { type = "pom"; sha512 = "06z4gkq3bh2pwyj8pvaly9fihd8gbgcqp3jxl05vkj2rcdb4jw3lw3hwn8f8ggqi17i2fdm8cbndkqgr9vdgiz45p8f1nx8kjlqikbi"; }
  ];

  plexusUtils_1_5_15 = map (obj: fetchMaven {
    version = "1.5.15";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0sya2d7nml8is8dfykyg7va1556ldnxxr90xynq9w5ghw8w8zz69hjhy5al91m4if11kc64d4ysssqqs6s83lxs75c0kipr4byn90gc"; }
    { type = "pom"; sha512 = "3ax5sy7x5l7c3qxj4vn4fyak0s6d7m2hbv2r79z5mr7hf0wp29jvg9jjlb8x6mdrg9q0i363j32b4mrvbxcdq7i128sqgc80c5jczdk"; }
  ];

  plexusUtils_2_0_5 = map (obj: fetchMaven {
    version = "2.0.5";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3g72mxvlsf18hl1vn9sq4i13nlpd66fkn2l8d96883f4n638sx031f8cnx6f08my3rfc67pypy4lsiagx2rj2x5ccqp9g9kzvbh4i5w"; }
    { type = "pom"; sha512 = "2rkkshqf3ahjijvr64ndzh10iksbz7pj0618drvg9iklnpv6i6y904fi31xjg7vxb3fy17k3mvi49pr2jxznbf1c8ndwbyawlvmw9j7"; }
  ];

  plexusUtils_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3n0g1xhjkjm0m3ch5wm34vxvldw889p401rlwqrlzm6nh53h36plq955v2vv30gjdgp7n54lpr4pb374fxz6wbzj385kphmsgxbsaxc"; }
    { type = "pom"; sha512 = "22g2dlbgc557k126hd0nfaf6n76vwa19nnd0ga8ywdx5pnai63x9806d7dhvjm778rmgpxlrj65y8if36q0zkbg153i007cxg36indj"; }
  ];

  plexusUtils_3_0 = map (obj: fetchMaven {
    version = "3.0";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "16m1khf9fafb9f79rbz93qgc35d8605v1qbs4ywnj4sk00d00d6n1649cc9rv593r8ghwd0rkz345z7wb00fagdr9af5h8h5w5blsa1"; }
    { type = "pom"; sha512 = "123fsmm1jvy571yl1s3wp7yd5k52nfjqxzqpzx2940rsigm35rw2mx1g4bvr3wx0gv5bqlfmqj5cwdhhxdq5vzrax8z5vbmdg5vb77r"; }
  ];

  plexusUtils_3_0_5 = map (obj: fetchMaven {
    version = "3.0.5";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2b7l2xwn606nn227fiqg47y4cda6apr4nv618f5swjnsji0gifw4dz4a9xyb7p0iy27igkj0j2l6kp3y4fc0vhvi7wn07zfcckswiyf"; }
    { type = "pom"; sha512 = "264k562pvd1cyh5danf56iyay1a661d15rywwq12fd3v8k7p85kl9b9ykqa5hssqkkixrv4gmhy6nkk5dhy5whbmlan99h6w6q0pjyw"; }
  ];

  plexusUtils_3_0_8 = map (obj: fetchMaven {
    version = "3.0.8";
    artifactId = "plexus-utils";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3745x0zvidknkzsl4p049c0qj0iv19ga9x9mfskl93r97nx7ip6qnwa9a0v9y3s5sy2klhlfg5dyyjnhr822529cv1p2dhlh46brknn"; }
    { type = "pom"; sha512 = "1p1l437rwpxv9jfygr25b455xymqcmm4smin1bf7fzcmgkc3m7k0gdd7rfvfg2622070rmwjbk4fgv0z3alf1xz03ksjp6s0gr6sqr8"; }
  ];
}
