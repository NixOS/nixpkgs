{ fetchMaven }:

rec {
  mavenSurefireJunit4_2_12_4 = map (obj: fetchMaven {
    version = "2.12.4";
    artifactId = "surefire-junit4";
    groupId = "org.apache.maven.surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2m6k4dsy9d6yfcn33lrv1q4lb3hlg1q6c8ff0rhb05j7lzsiiqa55n2561a45bznhc8l85l31mrvva0h2hhca6xjyx1hw7k3ddgpzc5"; }
    { type = "pom"; sha512 = "1na33q7j22fsdwcynd8pv8ivsq1fq51p818nyhhldaqnh7rm2478pnxyhq14wv9mrsgrfxffipaiqyvwq30y69y6ddn597arv16ihix"; }
  ];
}
