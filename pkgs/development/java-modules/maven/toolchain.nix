{ fetchMaven }:

rec {
  mavenToolchain_1_0 = map (obj: fetchMaven {
    version = "1.0";
    artifactId = "maven-toolchain";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "34kxv3l3676ddrsj2k02f9fmphcq16avafka950d5dclrcx7w37wgxx3gcf6zfixfx9zlbb7annsa05y8f0rx97g13rkqdfdj1wknky"; }
    { type = "pom"; sha512 = "0arkdm0bii7cm0g8qzzfih1jk9j7myn8w2ccr6j01wsj08gv7cbjr5k9jx1iwy1vzvhhsmsj6grq678zsgbvh4msn1s44i744x4fhvy"; }
  ];

  mavenToolchain_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-toolchain";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "37jjcjfx51bszg13wjhkv2spyw1b2n8glgyaaflzfqxmfhizr43y1fq2zhn2khp2jba6avilkqi9p0f2sd30glrg7lpc0srzqns3yn8"; }
    { type = "pom"; sha512 = "1r6w6za6smam46fpdfda2612ayz4a8gm87lgwa4f5jp5k92mzaj22rcsxlnibzly19vrgvycci63w9rgmzkwi2zvxxwxmf8sc5542c7"; }
  ];

  mavenToolchain_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-toolchain";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "02ya75k4n4w62s9p5y1mq758s33s6vqcqli77hknr4wn22rr5fgaax8qscdnj90w3y6rkr6w0afiw438wr4hxwns5vp90fkzym87bp6"; }
    { type = "pom"; sha512 = "1iv6k0pwyq2w5l4gfkmh818mrja0il48sajmgnpnn7ayi2238mbja07sqccm75wmzapb4039p7xq2jfp0vm41y3s00410gq3jgnf2pw"; }
  ];
}
