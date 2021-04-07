{ fetchMaven }:

{
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

  plexusCompilerJavac_2_4 = map (obj: fetchMaven {
    version = "2.4";
    artifactId = "plexus-compiler-javac";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "272iaf7mgmhjssj0k4a9r8rzb3c8pskb4aqypcdvj217l8hbih6rsqhh9nd2xmwrwa1ifvc336b8ihz6f419lj74gp4p1za6mp0nps3"; }
    { type = "pom"; sha512 = "1g16i5w610nsh9h0yyhw25fpr2lx562c4v8y17lw53imi4rhm0m709ysrbrh71rhv6f8g4i5d6wgps77jmdb5kn2h5k1n4n644wrd12"; }
  ];
}
