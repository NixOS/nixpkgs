{ fetchMaven }:

rec {
  mavenCommonArtifactFilters_1_3 = map (obj: fetchMaven {
    version = "1.3";
    baseName = "maven-common-artifact-filters";
    package = "/org/apache/maven/shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "21wyk4llwjyanlggy281f9n0sjshjqvd322lbhxmzn42cd9vmj0s6xih82jwqlkcxkypwymyj1gl7van55ibd98p1jjjvr93gs1cn14"; }
    { type = "jar"; sha512 = "1bv4lp1a8sb79almnygiq0pmm0fdhy9pyakp6xhz91b4v1cqg03sb586yc4lg2934yv4jjbybqjbh4l0y3kgnanjbxdxdgxgyf14iif"; }
  ];

  mavenCommonArtifactFilters_1_4 = map (obj: fetchMaven {
    version = "1.4";
    baseName = "maven-common-artifact-filters";
    package = "/org/apache/maven/shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "21wyk4llwjyanlggy281f9n0sjshjqvd322lbhxmzn42cd9vmj0s6xih82jwqlkcxkypwymyj1gl7van55ibd98p1jjjvr93gs1cn14"; }
    { type = "jar"; sha512 = "1bv4lp1a8sb79almnygiq0pmm0fdhy9pyakp6xhz91b4v1cqg03sb586yc4lg2934yv4jjbybqjbh4l0y3kgnanjbxdxdgxgyf14iif"; }
  ];
}
