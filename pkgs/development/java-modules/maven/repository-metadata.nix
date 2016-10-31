{ fetchMaven }:

rec {
  mavenRepositoryMetadata_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-repository-metadata";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3qh52jisq2facab5nw35pazf99z1yn8pfklvy8hcczd4dab1pj115jimfhpx48mmlaydaw50m006imfvlivxnadfxfk3887acmhp7bv"; }
    { type = "pom"; sha512 = "2sg2n3wxfanhf4jgmp2q9lh2hsnch54mzgh1clna2ywnnwh88cn37c9m9b6a0qgdc1m7yzlfg8r3k77ypfa3aa7hr3f9b2hi2k4pb0c"; }
  ];

  mavenRepositoryMetadata_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-repository-metadata";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2np435shcca1jka1gdjxs4bzzayfnfzncpnxhlfy59b32vfpvf5v0kca0zgyx7251ghhb2ks2xxd798rbzvr0gzivicwdrnd5x8g0hm"; }
    { type = "pom"; sha512 = "27b9z80qdkn7p4fs6k87a5i926c3dsr6jmq4rz8dyiml1svqsvvghzz59cby6n8wkx7wn003wk28jzc08x53vbk5zsvcg9ckslxhjyw"; }
  ];

  mavenRepositoryMetadata_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-repository-metadata";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2np435shcca1jka1gdjxs4bzzayfnfzncpnxhlfy59b32vfpvf5v0kca0zgyx7251ghhb2ks2xxd798rbzvr0gzivicwdrnd5x8g0hm"; }
    { type = "pom"; sha512 = "27b9z80qdkn7p4fs6k87a5i926c3dsr6jmq4rz8dyiml1svqsvvghzz59cby6n8wkx7wn003wk28jzc08x53vbk5zsvcg9ckslxhjyw"; }
  ];
}
