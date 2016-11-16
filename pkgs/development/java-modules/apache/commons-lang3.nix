{ fetchMaven }:

rec {
  commonsLang3_3_1 = map (obj: fetchMaven {
    version = "3.1";
    artifactId = "commons-lang3";
    groupId = "org.apache.commons";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "0msypmqn5q4sxks97zbvi85rq2zclkyz8j09riqw7c95n96nyv7x3pysi83vdgc53d0lhl4apkp7warl52xq1qzdyjxipjdlhqmhdcw"; }
    { type = "jar"; sha512 = "3lw2naanwxjqrwgbg5ij6abzlkch0l6bcx44sl4a59m2r5fi2rvmc07pqai2l9kqwql05fyx9h1md5jjh2wzia15rqnvwssprykjwvi"; }
  ];
}
