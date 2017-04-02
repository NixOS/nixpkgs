{ fetchMaven }:

rec {
  mavenPluginAnnotations_3_1 = map (obj: fetchMaven {
    version = "3.1";
    artifactId = "maven-plugin-annotations";
    groupId = "org.apache.maven.plugin-tools";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2q1y622vaks1y2qjbq4005jmi41hpkivsrnmkf5kr3zndz4d6ai47d90jwr70pby8xqqsj461baljcjsicl6rrbq0v9ppyryr13q828"; }
    { type = "jar"; sha512 = "1jd8b32kl9kh4dxpdg5i9qf3haqc5br0mz8bl1ri4hb9qgwkzsijvx6jr7pv9zgplanwvgca3lhpgzsgs03n8jlqnbxbmgsv1pl93zb"; }
  ];

  mavenPluginAnnotations_3_2 = map (obj: fetchMaven {
    version = "3.2";
    artifactId = "maven-plugin-annotations";
    groupId = "org.apache.maven.plugin-tools";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "0ggvy7xhlgbpb7abc7vj0bhdqzfc6x0d4ldj7bl8qyi0qhv404qlfy4iqhn5jv3qwmj2pp9w4fa9jv5vsaz6yh8hpkzgdbpcwxdrmb9"; }
    { type = "jar"; sha512 = "2j2lrm2dlikbpncz20r4yxhyi7h5dnhkxalvkih35m7fz57csbgd53whq969hixpfhyj18svd6695a3v4bfa94hg99mw78lzq8lwb37"; }
  ];
}
