{ fetchMaven }:

rec {
  mavenPluginAnnotations_3_1 = map (obj: fetchMaven {
    version = "3.1";
    baseName = "maven-plugin-annotations";
    package = "/org/apache/maven/plugin-tools";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2q1y622vaks1y2qjbq4005jmi41hpkivsrnmkf5kr3zndz4d6ai47d90jwr70pby8xqqsj461baljcjsicl6rrbq0v9ppyryr13q828"; }
    { type = "jar"; sha512 = "1jd8b32kl9kh4dxpdg5i9qf3haqc5br0mz8bl1ri4hb9qgwkzsijvx6jr7pv9zgplanwvgca3lhpgzsgs03n8jlqnbxbmgsv1pl93zb"; }
  ];
}
