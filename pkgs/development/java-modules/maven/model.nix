{ fetchMaven }:

rec {
  mavenModel_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-model";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2y6dqd0xlkkmff5gwfnc5pk0w6zpircj7mrvfw2nwvsaxx9cw3fkn33m3bamzyz1zv5w1vlrlrnynifvm3mzfrgkl3dxa16p00yj5wp"; }
    { type = "pom"; sha512 = "0mnjzcansaxakip9b2nq7pxl2nbf9033if8bap658q9i9fbm8b6djqs09frmdds1vns44vlirvmm94s2k7i1lswmsqjgv3p12lrvbb1"; }
  ];

  mavenModel_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-model";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0v4fzp4p71zjdxbf0lwjifydrxh9ag2c6pqc4n07hnr2rvcsx8n1rhb46ifaq6ycxps64fjnwkn29i5wlfqy9yfdh8gjs6i2sy523nv"; }
    { type = "pom"; sha512 = "1r5bk36120534ngqkh8rbxi0q0allkaqy6yxvs6s5vwjq0gvm12snp6y6vxvh5p4bljpfms7r4ljglgnnfdrl8l8vmrj0af201gnv3m"; }
  ];

  mavenModel_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-model";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "14pxgdcim20x9lisf510nazzlcjxv9fpqabkdn0d86qa7d9270m4fmya5crasx2np9h0gxl407d77vcjf99fdxizg7i32w35yljqp3z"; }
    { type = "pom"; sha512 = "2vvyawhfq0gwa54ir5l2drcfxphkd47ghwgz89v3vsqgjry714vp01pa5a6yjlwfd45mknyrb71ws6dki4zjgzhdm09ck7cxg5qkpr9"; }
  ];

  mavenModel_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-model";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1f9ndvsxpiyybmr5p4pl0xrvxap17grad10vr0pskvx8g8phy7w7kmihhg8gd8m91nbikpaqycm54dp5xmhqzyq85dqapxbiy2m599v"; }
    { type = "pom"; sha512 = "11imkxiw9wbgnv7zpghdmgpf02v668z78xr5v0cqyay88ph7wjbscwllbgx3v6rayffx64jbhlvsw97m9sdncrfih2c9wkvfp5m48kn"; }
  ];

  mavenModel_3_0_3 = map (obj: fetchMaven {
    version = "3.0.3";
    artifactId = "maven-model";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "13b339n0iibvy9x1d34b6gsnlz2s26ap866nhm4wyrlb0hkyb4zf7xbvc8aigr9zzzc4msn3yi98ylgsbinxx8dkbs89x1amnd7v1nr"; }
    { type = "pom"; sha512 = "38dbv2z16h1wq16pxx5nrpndpkmnmj6wxsa4x13hsm7skmfwxdr51ddjddc4qlqk9dfnny0yv3lf009k0pfs06hfn0xiv85ki5y1hfg"; }
  ];
}
