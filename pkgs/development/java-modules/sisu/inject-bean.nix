{ fetchMaven }:

rec {
  sisuInjectBean_2_1_1 = map (obj: fetchMaven {
    version = "2.1.1";
    artifactId = "sisu-inject-bean";
    groupId = "org.sonatype.sisu";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0cqplf149dlqyqwaqk3bjlki97fbnav57vv5d9kkd2lvdradp7k89m5niwg5qgsfdlj91zidgrrkls5vyr4dcdy3lhxs1wyr4y8r0qb"; }
    { type = "pom"; sha512 = "39dwwfh1p56crmx187wbm2kskxbcr0dfysdvqiwjfx91yhh64l9672axi28hdaw1qd5dh6whzxfqqlfjac94r37wv6fq5pkx6acp2dn"; }
  ];
}
