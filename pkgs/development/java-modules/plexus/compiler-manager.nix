{ fetchMaven }:

rec {
  plexusCompilerManager_2_2 = map (obj: fetchMaven {
    version = "2.2";
    artifactId = "plexus-compiler-manager";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1r1sdj784x4zcnkaz840vsz36jn1p2j98c21nia56kcdl1njydjn714bsmdy816l6sdinkz4s196mm3hshmxhq8mkmf16wgxx8jnq94"; }
    { type = "pom"; sha512 = "3cpfnbgil6g0bgq0cjbq2ysfjdpl05fh72d9l9cnwbilcsaxcmzn1hgmmkvam2ih222nl82dy7n5020is3y05kiv0i4n4lcs5m0ia48"; }
  ];
}
