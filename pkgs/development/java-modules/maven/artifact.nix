{ fetchMaven }:

rec {
  mavenArtifact_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-artifact";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3xmim81k0p3l7fpgr8xlbj3mcz83d1rw3nwzdlrnwh3nkc5xryxl8fx499351vjlmjs009bhd68a20v59y3flxz8hxiy07cijgcbqnx"; }
    { type = "pom"; sha512 = "30y2mirgqvdm3gdalxkzjljswh9xhygsw6v2jfrd9y61wqng2hzyn7dawkn5q4cyiknmw1b9660pvbnysvh3rbic75lhw5xqqgdjmih"; }
  ];

  mavenArtifact_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-artifact";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3kkv5kf3k5in69aplawkr0cr2cviyjgf8k6r6qvgxk53i3jmh7qylzrwkrd9bxclkjkgyg77cffxm48qhxm9pyqncdbwjldsmmdfb4f"; }
    { type = "pom"; sha512 = "37kvfxcpfajjn9lmvh5kay4y61ri1190hxxgiil8fqfvmvcm02jcqzfi4ry0nzc80g5fsarsd3s2ns2d8l0lnqjp28nn51dixm9a55w"; }
  ];

  mavenArtifact_2_0_8 = map (obj: fetchMaven {
    version = "2.0.8";
    artifactId = "maven-artifact";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0i2xd2fkvp5glb7yx8zhh96px4v2yq0bgxa6xxcy6if0sn8c3vps8jmd1z3ys27jzj1gvwgg4rpa17k0nk1c8szz1v7vwvyhp7s22pi"; }
    { type = "pom"; sha512 = "37563kfswgk9yfzm46vk4nr44rncdd3y705vgg20lj4nsrqn7iwg55fx1a4f039gbaf8dzb6xwp0ypyspsx9q742wkwrsr5q41d99v7"; }
  ];

  mavenArtifact_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-artifact";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "17g913m1zbrvarkwvmz5xx9nv7mrk2984rc9pkbc2laid7n1nb226g0262xyhcnc2s57av96337ag6jg2bq9p1kgx7gbd2z6gnvkkia"; }
    { type = "pom"; sha512 = "0g0cbqihzxyaa1b0z9a7qb8lkhcm8bzxi7qnqaab2n2zaaql6jyy7cf4z4yzqw3yfj7ylqvydiwp32j2c7nqacyx0hmcydqkqg46kxv"; }
  ];

  mavenArtifact_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-artifact";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1wfffq39ay1cdzany6x0d6h7icdqrvmj4py35a8i2aw94bc8mf6cam7lf8z7jjckhrnb7yxbqz6pj8sxsgpkwnl2q4flqaczr8nnx4j"; }
    { type = "pom"; sha512 = "099hkdbccd9cf6w64c37z1b2i54h4y0bfx5n56birikgy3s92rrl4x454gvw3wnrpvhkikwvdyw9dv03w40rn50kdwgy0mxc3zgs6l4"; }
  ];

  mavenArtifact_3_0_3 = map (obj: fetchMaven {
    version = "3.0.3";
    artifactId = "maven-artifact";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0f842m7wi9ajvphgshnmsn8dppiwr326yp663gic45xzkpfvka118npl8xxqnr683dipvbnbrddim974qcpz4mgpypir0922803i3qv"; }
    { type = "pom"; sha512 = "3wpambpgm68rap906gdvwlbywgjs57nkc8k05r8rx701800zbpwlrzc9b3ipxgjb7y6f2z1vi14yj9ia12wv7k8jn2aspf31pzp5plq"; }
  ];
}
