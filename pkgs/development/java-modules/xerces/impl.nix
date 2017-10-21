{ fetchMaven }:

rec {
  xercesImpl_2_8_0 = map (obj: fetchMaven {
    version = "2.8.0";
    artifactId = "xercesImpl";
    groupId = "xerces";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "09nwhb52g4ak92l8d0aymasbgjxmk4s7vp7i55l38x21zq1plxxkdp2sdk110qyg5mw06y433v28fm867jybpca8zrx51w4g7wg0w2y"; }
    { type = "pom"; sha512 = "3lv2zqm25mmirazrpp53dicd3ficy32mdr3r7bc7xhmjky2r0051vzh5k0c01rwlb4kx0rinysxw9k20ml96ivw6ipwlrvpxjwgb74f"; }
  ];
}
