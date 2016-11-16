{ fetchMaven }:

rec {
  mavenSharedIncremental_1_1 = map (obj: fetchMaven {
    version = "1.1";
    artifactId = "maven-shared-incremental";
    groupId = "org.apache.maven.shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1g2gsk3s5v5dg6y81a2046aqf5v19jn6i0jwha78xi3gyx7ajgxkdn2wswf9gdxxvc44qk6lzn33bl3pk3vl1b84h2hdxz7yyhajbfr"; }
    { type = "pom"; sha512 = "2fqj1p1059v462casy2mzj1bg8mawb5lihx5430px9440vyl1iggqg598r6798162m8c7ilav3x71x763rchhskpqakfkvydkjhrjfr"; }
  ];
}
