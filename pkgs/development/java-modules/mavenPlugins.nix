{ pkgs, stdenv, maven }:

with pkgs;
with pkgs.javaPackages;

let
  fetchMaven = pkgs.callPackage ./m2install.nix { };
in rec {
  inherit fetchMaven;

  animalSniffer_1_11 = map (obj: fetchMaven {
    version = "1.11";
    artifactId = "animal-sniffer-maven-plugin";
    groupId = "org.codehaus.mojo";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "224y5klr8pmm4g3k1qcqrbsjdng1nc9rfzlrk5x50q3d8pn0pj7jr1wg58997m217qimx4pwgcdbgl9niaw0xg136p76kd4hschbxda"; }
    { type = "jar"; sha512 = "24dih4wp7p1rddvxcznlz42yxhqlln5ljdbvwnp75rsyf3ng25zv881ixk5qx8canr1lxx4kh22kwkaahz3qnw54fqn7w5z58m5768n"; }
  ];

  mavenClean_2_5 = map (obj: fetchMaven rec {
    version = "2.5";
    artifactId = "maven-clean-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1dc1jd65pz1wl0hr89a8v4g8kd2hcixcdlpa102ffm03mmddc1862whbj9hppx3i3297rahrwl81cph3cdc866fbhbgaj7wld2649n7"; }
    { type = "jar"; sha512 = "2fprppwpmzyvaynadm6slk382khlpf5s8sbi5x249qcaw2vkg5n77q79lgq981v9kjlr5wighjzpjqv8gdig45m2p37mcfwsy3jsv89"; }
  ];

  mavenCompiler_3_1 = map (obj: fetchMaven rec {
    version = "3.1";
    artifactId = "maven-compiler-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1dqav3mb4ppg9l10qw04galjmf7yhlyzdna5ldpp3pmpsqglb8m2ab1q324ansz29dbp014w9c7na703jk7qzrja1ilxj0w71rpmsd5"; }
    { type = "jar"; sha512 = "1dvq13yc8yacxr66pkvwwd4cvx0jln8dv9fh5gmd5vir05h8l5j4y324r1bklnzpx0ancs5ad8z944zgmpaq3w195kfsarmndp0gv2y"; }
  ];

  mavenEnforcer_1_3_1 = map (obj: fetchMaven rec {
    version = "1.3.1";
    artifactId = "maven-enforcer-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "0w47gx4ksksnl9siq954g2zvx8gx0qa6q5kp91qyyk88c65mfqjjm19613h3dhfmjq9f4rl8b1qhrq35gy7l90aplnibcimrpm6w6nk"; }
    { type = "jar"; sha512 = "15sb9qmxgbq82nzc9x66152va121vf33nn0ah2g4z169cv6jnjq05gk1472k59imypvwsh9hd3hqi9q6g8d0sawgk5l1ax900cx7n25"; }
  ];

  mavenInstall_2_4 = map (obj: fetchMaven rec {
    version = "2.4";
    artifactId = "maven-install-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1s5isapjz7mp9cl0jvk8nd1amrasdk257zbil76yabd1h89q4504y01482lxh7sp7x4mcqzj00i6517qcfdzf6w99cnd8dxwgkwqq06"; }
    { type = "jar"; sha512 = "35hbj5hbz085y1dxfmza6m207kn68q2g1k5a9mc75i9pj8fww7xm7xzcdv81xyxjm3r4qbqf1izlg16l99b93rfii9rg8kqz8mxqmb6"; }
  ];

  mavenJar_2_4 = map (obj: fetchMaven rec {
    version = "2.4";
    artifactId = "maven-jar-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "12pj3lg7gf0c9hisasrks27b3a0ibvmlbgwbx7p1dcp0as40xwffrx57am7xpqv5bzwl5plh7xxd7s14yyvk8dybjhlj7shqmgn973r"; }
    { type = "jar"; sha512 = "0frbikq8jm5pynlmv51k349kiaipd9jsrh6970313s0g6n4i0ws9vi232wc1mjrc3d27k63xqmb97jzgbbc6q337ypv5vil1ql9wh0d"; }
  ];

  mavenReplacer_1_5_3 = map (obj: fetchMaven rec {
    version = "1.5.3";
    artifactId = "replacer";
    groupId = "com.google.code.maven-replacer-plugin";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "08vz72v426hd8bzpz2wd003r4kz7rn5syva5picppgwdj69q8xm4dj78mx39ywsgzv2x8jd3w3jpc23pgr07dqj5h2kyj44147lkhsp"; }
    { type = "jar"; sha512 = "0f2rngcxpll0iigv115132fld5n6shjfn7m981sg7mdzlj75q2h5knd4x1ip33w60cm1j0rmqaxp1y6qn76ykvhprdyy9smiy667l9x"; }
  ];

  mavenResources_2_6 = map (obj: fetchMaven rec {
    version = "2.6";
    artifactId = "maven-resources-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3rki0dhs3y7w9vbvwf2i7hmq9vismcfq79cdzd3qfs9bva4qxikx939idg8jmwnwaqww4q3wmgwg5vx3n910m8m2xr83x6y0dm62vbk"; }
    { type = "jar"; sha512 = "3j8smsx6wk085iic5qhknrszixxna6szmvk2rn9zkn75ffjr7ham72hw9cmxf5160j73n8f2cmcbw1x462fqy12fqqpmzx08i1sbwcv"; }
  ];

  mavenSurefire_2_12_4 = map (obj: fetchMaven rec {
    version = "2.12.4";
    artifactId = "maven-surefire-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3qkzmh5fk3s7y3qy91qck1nc0yadwsizxy61wp410dspsd73cchqll7vjl11cj6k5kywjxsl9dihy2gp949nh8380lbvs11g83wrgmv"; }
    { type = "jar"; sha512 = "2sjq2l8i97h3ay8wwrsi75cfs9d1im5ar2sn2zv4q6xsv4v3hh5y481l9xwc5dnbcfdjs38ald0z60pxpcyiqrng6h69s2ws8fhb0mm"; }
  ];

  mavenSurefire_2_17 = map (obj: fetchMaven rec {
    version = "2.17";
    artifactId = "maven-surefire-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "367j67yy8jyq0k7ycnf9ixjy0rl2xb7cz0hwvh9rcbxkbr687bwam2gss0zdsr44q2ndk5hlcq56hhngp055194p90hkcvgr343ng6y"; }
    { type = "jar"; sha512 = "3vhs3djga2ni3bsldn7jml8ya3vgvqaakiybj9y77q8z35xcnf34hsxkmlpm6mbyl5afcv2ij6syas0zppshqbp64ibx7bsqnfi0zbl"; }
  ];
}
