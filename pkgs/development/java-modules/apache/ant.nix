{ fetchMaven }:

rec {
  ant_1_8_2 = map (obj: fetchMaven {
    version = "1.8.2";
    artifactId = "ant";
    groupId = "org.apache.ant";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3x9m09i4kn57avkjbz57v1chx0356lp4mz77adslcbmr59gxfs3km1f4dq3lm1nxspldwxqk654yzh5sgrcfz13r1zlg3bvlsjbb1bs"; }
    { type = "pom"; sha512 = "2h8ajn6x40cn8cicx3h167blkv9p6478l610xrp2n1k1zlfnh1rz2kcsi74gy7psb4h98118p3zp90gvw4h8gsphz1n30f3c96qnpiq"; }
  ];
}
