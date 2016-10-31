{ fetchMaven }:

rec {
  mavenToolchain_1_0 = map (obj: fetchMaven {
    version = "1.0";
    baseName = "maven-toolchain";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "34kxv3l3676ddrsj2k02f9fmphcq16avafka950d5dclrcx7w37wgxx3gcf6zfixfx9zlbb7annsa05y8f0rx97g13rkqdfdj1wknky"; }
    { type = "pom"; sha512 = "0arkdm0bii7cm0g8qzzfih1jk9j7myn8w2ccr6j01wsj08gv7cbjr5k9jx1iwy1vzvhhsmsj6grq678zsgbvh4msn1s44i744x4fhvy"; }
  ];

  mavenToolchain_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-toolchain";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "34kxv3l3676ddrsj2k02f9fmphcq16avafka950d5dclrcx7w37wgxx3gcf6zfixfx9zlbb7annsa05y8f0rx97g13rkqdfdj1wknky"; }
    { type = "pom"; sha512 = "0arkdm0bii7cm0g8qzzfih1jk9j7myn8w2ccr6j01wsj08gv7cbjr5k9jx1iwy1vzvhhsmsj6grq678zsgbvh4msn1s44i744x4fhvy"; }
  ];
}
