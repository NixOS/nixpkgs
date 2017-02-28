{ fetchMaven }:

rec {
  sisuInjectPlexus_2_1_1 = map (obj: fetchMaven {
    version = "2.1.1";
    artifactId = "sisu-inject-plexus";
    groupId = "org.sonatype.sisu";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0qklkc024xc58ayl6503ig1yhpsvhxk5fc9vfb7xny9v8w2ds3f9yvd275n8iyy6iza0kj8xlk0clq1i50k96j11lf401r2vcfnk69g"; }
    { type = "pom"; sha512 = "1fcpyrjz82v0lncyndrw61bb1p9kxzlikiw6qk2v71zgfz2cggw694g26nxsppab2d1ps689sijb9i934vf5bpkdvkc52ipbc43jwr4"; }
  ];
}
