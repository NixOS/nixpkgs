{ fetchMaven }:

rec {
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
