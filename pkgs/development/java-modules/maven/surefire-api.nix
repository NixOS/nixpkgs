{ fetchMaven }:

rec {
  mavenSurefireApi_2_12_4 = map (obj: fetchMaven {
    version = "2.12.4";
    baseName = "surefire-api";
    package = "/org/apache/maven/surefire";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0chjp4jpfrhd99mpvh6v4sz71wgg8r0nyv8j2mgbsxsvbf0wha0za5g5bv16l4pflfigd4rhb2h1mkz51pb71qli8w39ycb3dw4lfpn"; }
    { type = "pom"; sha512 = "28ra2n9ln8nb5j1xh6mnxc4kfabnvyqyrgy2wwm66pxhp1fxxxqz1izfvih9jzr3cps7pbvqwql770i14cfyjzvl0zccjsscsjyy50r"; }
  ];
}
