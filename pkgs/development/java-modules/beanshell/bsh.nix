{ fetchMaven }:

rec {
  bsh_2_0_b4 = map (obj: fetchMaven {
    version = "2.0b4";
    artifactId = "bsh";
    groupId = "org.beanshell";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1xgl3zw2gaca7f09224k3bi22dqdcd589c5jqk7p87s6dlbaai8sivklbq225yxmcpmwsi98r0a6xlgxnxnhk3b0qplf1bj4qp17dx9"; }
    { type = "jar"; sha512 = "1idcadxcphpqh2f6qjijd2gdcklcv9qmv1aalh2z5rk5vipqm89hm05lwjapw2gy5x5q1grzxraalnspbhacrrwm15np07580k6vki9"; }
  ];
}
