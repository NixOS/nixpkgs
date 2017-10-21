{ fetchMaven }:

rec {
  plexusCompilerJavac_2_2 = map (obj: fetchMaven {
    version = "2.2";
    artifactId = "plexus-compiler-javac";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "12xsiaqd1q6mmmkcsxf4nr4wdjl8fa1nwz32yqwrrbj9cgakph0368cnk1apjzngsmnl6bws87nlxcz64sg0rb7i2vdzggplj0a41br"; }
    { type = "pom"; sha512 = "1fv2ij4h9xmzv3f5mvs0ilhkw7khkw5v8n1d97a2canfn254fipz7pd9nkmkqzjvy3cqwiczyh2nzibvcii624p8ggwl4s3yjw92jx4"; }
  ];
}
