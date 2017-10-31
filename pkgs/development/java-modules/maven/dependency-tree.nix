{ fetchMaven }:

rec {
  mavenDependencyTree_2_1 = map (obj: fetchMaven {
    version = "2.1";
    artifactId = "maven-dependency-tree";
    groupId = "org.apache.maven.shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "29ibiyc1x20yrnxgcpvvf3k0pcjq63l98lakk10gipmx8a7bqs6m7npcqhzq6a3xrrcnz4pp7mj9gkmcs1svhg3qj4778cdax5pfy39"; }
    { type = "jar"; sha512 = "3mr5ph5yngfvqwvrbiwvs66d8gbhpjsp009q5hrarkg53kwlphy6rmvdkfzp4j5rz8dd4cirv7vf6nhhrpdnjy2fc8bhx2s61zissnd"; }
  ];
}
