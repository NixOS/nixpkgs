{ fetchMaven }:

rec {
  mavenSurefireCommon_2_12_4 = map (obj: fetchMaven {
    version = "2.12.4";
    artifactId = "maven-surefire-common";
    groupId = "org.apache.maven.surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3ny5b6mnmka3lzyqk03flmizj82c0hdbiqgcqxj7261pvcf2drrk85p5q2z6f2h15w60mhyvl80p39pzqa35ziqhqnp6walg7rdk0hb"; }
    { type = "pom"; sha512 = "3iagspjgilwhbh5sxi64b2q8dpgrwa0s9wiw2417z2lvghy8knszha62n3j9qvbn7pxy819f2981s41aan6wcwx5scr9sg8jwbvcmff"; }
  ];

  mavenSurefireCommon_2_17 = map (obj: fetchMaven {
    version = "2.17";
    artifactId = "maven-surefire-common";
    groupId = "org.apache.maven.surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2ikw1ddnxxfglb3k4920lfr8ziav5n2wp13452bxyd1gbhpwkq0js58wy9jbhyzqgdblqhfj3syxka0mxd4vngyg4iqw3c2phslmn6i"; }
    { type = "pom"; sha512 = "1l2dkbzbi80bjsh4ri6gxw84iwzsm5g6mmhrj1ndrsr66d4cg7vg5nfyqxvf7xhzwj45768y5id09r70zijliavpsxrvjq5j0g05yb6"; }
  ];
}
