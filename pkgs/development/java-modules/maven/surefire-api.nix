{ fetchMaven }:

rec {
  mavenSurefireApi_2_12_4 = map (obj: fetchMaven {
    version = "2.12.4";
    artifactId = "surefire-api";
    groupId = "org.apache.maven.surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0chjp4jpfrhd99mpvh6v4sz71wgg8r0nyv8j2mgbsxsvbf0wha0za5g5bv16l4pflfigd4rhb2h1mkz51pb71qli8w39ycb3dw4lfpn"; }
    { type = "pom"; sha512 = "28ra2n9ln8nb5j1xh6mnxc4kfabnvyqyrgy2wwm66pxhp1fxxxqz1izfvih9jzr3cps7pbvqwql770i14cfyjzvl0zccjsscsjyy50r"; }
  ];

  mavenSurefireApi_2_17 = map (obj: fetchMaven {
    version = "2.17";
    artifactId = "surefire-api";
    groupId = "org.apache.maven.surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "319kkasis86cqimkvsvmry60sj9m1f8vmhawpa8a56arqxfiqifnjiqfppydzlm3hlk8m4qgx3k5s291acbrv05297db8qbcrb2n688"; }
    { type = "pom"; sha512 = "0p0yc6sq26jsa19iiqy8d0mw3q0i1jmqz21m8fp855i8q07iyqbd1lmzasfdbblki52fdyk986mdw26yhznkr29hgpy8qv7f0l6a5pz"; }
  ];
}
