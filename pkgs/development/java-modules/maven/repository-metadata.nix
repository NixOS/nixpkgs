{ fetchMaven }:

rec {
  mavenRepositoryMetadata_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-repository-metadata";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3aq5k4ifam2lm6mny7zyjlylcpk6is2jnas81w6z5p6qd5jfwfj1i3g89y0vsl7mamh2rp7xncx60mvqr0jm9hxgx8ibjcynkq92kaf"; }
    { type = "pom"; sha512 = "29nynsxh8k1q91whs4glca3qxigid32dx70c87jvk1x1cfc8s78bvm6lzr14x7wvw5i5n61lrqvq5mc6mzsi8xmspaqjhm2m7azyx7y"; }
  ];

  mavenRepositoryMetadata_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-repository-metadata";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3qh52jisq2facab5nw35pazf99z1yn8pfklvy8hcczd4dab1pj115jimfhpx48mmlaydaw50m006imfvlivxnadfxfk3887acmhp7bv"; }
    { type = "pom"; sha512 = "2sg2n3wxfanhf4jgmp2q9lh2hsnch54mzgh1clna2ywnnwh88cn37c9m9b6a0qgdc1m7yzlfg8r3k77ypfa3aa7hr3f9b2hi2k4pb0c"; }
  ];

  mavenRepositoryMetadata_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-repository-metadata";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2np435shcca1jka1gdjxs4bzzayfnfzncpnxhlfy59b32vfpvf5v0kca0zgyx7251ghhb2ks2xxd798rbzvr0gzivicwdrnd5x8g0hm"; }
    { type = "pom"; sha512 = "27b9z80qdkn7p4fs6k87a5i926c3dsr6jmq4rz8dyiml1svqsvvghzz59cby6n8wkx7wn003wk28jzc08x53vbk5zsvcg9ckslxhjyw"; }
  ];

  mavenRepositoryMetadata_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-repository-metadata";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1dhyh2m8kwys6b1pqnyrn9f9a0bm93xgy9d0nyr98sq3v14irmk6kaf91rgrzrgg5b526816gb41gw1i0rdsrjdgnawlml5dm4qqc8g"; }
    { type = "pom"; sha512 = "3xcvc4rsmxsxadsqczzknyrdvklizbd6wr1ldvkqx0vqwwm89k9brgkvb5bqv5i3g8s3izx1xn4g24ya88qmgr3h231wpjby2nihdvg"; }
  ];
}
