{ fetchMaven }:

rec {
  mavenDoxiaSinkApi_1_0_alpha7 = map (obj: fetchMaven {
    version = "1.0-alpha-7";
    baseName = "doxia-sink-api";
    package = "/org/apache/maven/doxia";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3lb710zyldqysy19cgsan6mb5yrxx07vphddasq4kv1z9p5l4mpx9jq8fdhcxm4bgrfpdxkrdy2z4h2w8kc3gp2dk5g515x854jhqar"; }
    { type = "jar"; sha512 = "0q2vn7yyl8qvsifb629jh3hmaa5pkj5y22zy7qbji1xmn28qp0n1skfvlmpn0m8djwzmayw6xjbxhxvspzc9a14n3nkmjzmr5yz053a"; }
  ];

  mavenDoxiaSinkApi_1_0_alpha10 = map (obj: fetchMaven {
    version = "1.0-alpha-10";
    baseName = "doxia-sink-api";
    package = "/org/apache/maven/doxia";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "31n980rx8m3sy6ia6izdjmc95pd8gvy31a1j933qznvs10flsf3gvmnywcyncf9y4pvaynddqjfvjpvf1qkxcw9jwjcmq7ka3325fi9"; }
    { type = "jar"; sha512 = "1bgp929njkqvzv1q07drfncqagpkfw1ksi0cvwqq69ww2lbg3rmq2if11j7ldwn2rdvmfrr9qyhg34vwz13gfh7yylkw0il0q9h9hlj"; }
  ];
}
