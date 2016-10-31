{ fetchMaven }:

rec {
  mavenSurefireCommon_2_12_4 = map (obj: fetchMaven {
    version = "2.12.4";
    baseName = "maven-surefire-common";
    package = "/org/apache/maven/surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3ny5b6mnmka3lzyqk03flmizj82c0hdbiqgcqxj7261pvcf2drrk85p5q2z6f2h15w60mhyvl80p39pzqa35ziqhqnp6walg7rdk0hb"; }
    { type = "pom"; sha512 = "3iagspjgilwhbh5sxi64b2q8dpgrwa0s9wiw2417z2lvghy8knszha62n3j9qvbn7pxy819f2981s41aan6wcwx5scr9sg8jwbvcmff"; }
  ];
}
