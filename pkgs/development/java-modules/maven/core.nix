{ fetchMaven }:

rec {
  mavenCore_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-core";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2q4s5y8bpa73a10r4m9qgzfsczcap147p5gcc9inm5fx9x32sbr7zqw6xj7igsyjb9qsqpp3v727xv3ng57gczdqs1dazljqrgk9jal"; }
    { type = "jar"; sha512 = "2ar2qvhig92gifm4zhd7mzcm0c7cnlyvd3d089a7chlvxhrxyhf08xxpd8sxa525sa413v2d762yx2mbhnkf564i1zw4gg7cdjl5z47"; }
  ];

  mavenCore_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-core";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1a17qcd05v08jpd9ah650kbmrdxrxjfl2jgx9fnc89x4ahzmml9fr2qal0pwnn0sw3g3j1cqbry9lwq5hzja6x779s90hqrb72s49l1"; }
    { type = "jar"; sha512 = "0qp0kns07h4j7d67z0j09kjn0hwf6k6iz4vp2pmisx131f98acm516y8ca35ly7pp6zn9mdk3c4nh9c0rd7xnqvi12ijqrfvg01dri2"; }
  ];

  mavenCore_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-core";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1a17qcd05v08jpd9ah650kbmrdxrxjfl2jgx9fnc89x4ahzmml9fr2qal0pwnn0sw3g3j1cqbry9lwq5hzja6x779s90hqrb72s49l1"; }
    { type = "jar"; sha512 = "0qp0kns07h4j7d67z0j09kjn0hwf6k6iz4vp2pmisx131f98acm516y8ca35ly7pp6zn9mdk3c4nh9c0rd7xnqvi12ijqrfvg01dri2"; }
  ];
}
