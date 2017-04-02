{ fetchMaven }:

rec {
  aetherUtil_0_9_0_M2 = map (obj: fetchMaven {
    version = "0.9.0.M2";
    artifactId = "aether-util";
    groupId = "org.eclipse.aether";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1qh3vzdf33fffsry9256vbaskhp0xsw1d8s7c429a1hiyz8qi9p2sqsh2mqj5vrfj0mxri1nm68pv0nm9fhqzrwfy6f2sihl8rp7df1"; }
    { type = "pom"; sha512 = "2a0z5r5avm7gfkabkha6h1b0gbnma725dqby9wz6lhhkwqhn3zmdr69a0ll6vfh1mv0ir4spcr02hi61xlng4lakdlmwllm0g5ixaiz"; }
  ];
}

