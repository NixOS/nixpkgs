{ fetchMaven }:

rec {
  mavenSurefireBooter_2_12_4 = map (obj: fetchMaven {
    version = "2.12.4";
    baseName = "surefire-booter";
    package = "/org/apache/maven/surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "08l0r0s1jhjdgljh26m4i612kf6wqs6g8lwx9n0cccjjzlpn3sxg7dryagwp2gz2g9y5kpdmbpsxmp5imbdak3qrwa56wxrmik16jh8"; }
    { type = "pom"; sha512 = "3rj97rbbdm0m0f1cpbvw7mc9hc5jmfkqbg1w1ggr640bd8fzrgmxrcynxf440mf0wg4xy55v27g6v5c3z20zlw1h4qi500x6wfm0l5s"; }
  ];
}
