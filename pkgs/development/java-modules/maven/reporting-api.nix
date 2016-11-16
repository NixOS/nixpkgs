{ fetchMaven }:

rec {
  mavenReportingApi_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-reporting-api";
    groupId = "org.apache.maven.reporting";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "06721y3g8zxhv2hx9c743ai3pc8d2agdgkz8wyaia6h7k2sy0rjxcfixpdxpw9hzdm0fqjqc3hdjf0j5dlkd11xzv9q87dr1s1x24w2"; }
    { type = "pom"; sha512 = "2xjij0375hnv807sar41gk0qk8f7xaqm1fkrgvrbcl5sbwm614rrdxir14wlkkgr78qjx3b8m3r1jrdi47j1n5p4c9zmgg4vjl3n1sy"; }
  ];

  mavenReportingApi_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-reporting-api";
    groupId = "org.apache.maven.reporting";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "236xqa5bqih3lkfwdmfsb4wgkn8mllnzpnr4dhzch2jlhcsvl4fm1zmawk1njd8ibq9dyfg3n41a6hc8ydndh0ffxdm1mjnch9bv1da"; }
    { type = "pom"; sha512 = "3vlfls0g1bjrjpgzv6zlfglr1gxwm9m6zm88m9ij8ap934cxrzqj7pkqyx0s2vc8j700xgrwj57ahmfdrdi4v1arav1m1790plbip3y"; }
  ];

  mavenReportingApi_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-reporting-api";
    groupId = "org.apache.maven.reporting";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0x7j7k3xbxps80swyp4ff1sw4rwrhlxsx80kyh0sj0i9jz50x18p1rba10gx2fqd4l29zri77nlm4qza5yrf61s68xby2zr2bygyc9r"; }
    { type = "pom"; sha512 = "054v1p9h0141pahs52pg8wb0x4jghm5222yns6mf4dbc9gpy7x9j2b0z2lv9q3slx98378s4zakx4kbk5ca9ldlm8sz9y10fpqm35s6"; }
  ];

  mavenReportingApi_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-reporting-api";
    groupId = "org.apache.maven.reporting";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "38nbplfyi1xcf6q502m8sgz9iacqy06y9fq811sz75wsqxld8zxkr85lqg46zhpjm8k3hk7dg4an466j65mbpf0n7iswcjnqn78slil"; }
    { type = "pom"; sha512 = "0clwbb7p9fm5xlwkjyxx97v0k9alpz98smlpv26gz9j22hlzl08zajgiw52abqarbk80x28c02clipv1ifgbwrxyji4s8rb5f689nkp"; }
  ];
}
