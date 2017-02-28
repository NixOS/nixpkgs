{ fetchMaven }:

rec {
  ow2AsmAll_4_0 = map (obj: fetchMaven {
    version = "4.0";
    artifactId = "asm-all";
    groupId = "org.ow2.asm";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3b38kqyzg15plsdwwr5kri06h0pag1pxnxzlyqcwpaa2ncd4pqh44zc7mzaxrsvpx8z5cdl413xs2p0qn1qhcz92w5lqykm4gnvb2az"; }
    { type = "pom"; sha512 = "11gcdp8417immlsb8dvw70cmqykcqvzcl2xz37vsimdpwjx31px88dgmxs6l3k50z9mvs6h1cfgfbaw1i2qmzdkdlbyai8iwnl8q2mr"; }
  ];
}

