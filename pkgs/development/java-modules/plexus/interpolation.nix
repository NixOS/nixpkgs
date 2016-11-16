{ fetchMaven }:

rec {
  plexusInterpolation_1_11 = map (obj: fetchMaven {
    version = "1.11";
    artifactId = "plexus-interpolation";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "064lk1i6x9jj0yaiw2j1738652mxwi6qavagi364dj0pyg65pp875hs6qv1kc4gpzk60ksr99mg49mhb216p0lim83xshrxqj9i5j2w"; }
    { type = "pom"; sha512 = "2laqd4iv9mj4r7kdm0zyc07pyi04p1svb27fdzm2w4y3kmi4z5h2cg39rpn6slf8wmfnk3zlcj3w662sm1fy47qzdjwkkjil0fgv3m3"; }
  ];

  plexusInterpolation_1_12 = map (obj: fetchMaven {
    version = "1.12";
    artifactId = "plexus-interpolation";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "239qj01vsvn7rxm67z15lgc4nc6lqas3fkxx8an5dddzsdjh7vm99ya576abwzngcm4ckz5d0dk7qx9rgsz6b9rwjq3zvqahmaw2h7a"; }
    { type = "pom"; sha512 = "1jpkc2q1i325vscq9ryww1ip7vgpbzcwv23ks18b33gdxpkw25kfzncpcnpdg9fy5jn60fb6jhngxz9mkxnzyl0p3sfkkarwcmcx881"; }
  ];

  plexusInterpolation_1_13 = map (obj: fetchMaven {
    version = "1.13";
    artifactId = "plexus-interpolation";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0sm1kaxsvn8007br7nr9ncjppmfkp8nzr6ipwwx86idai9bqcsm4kh2scxf893s4jf2ii7f5106dd5w4h7bw67csalhqqzi1zpndbk4"; }
    { type = "pom"; sha512 = "3hlv9l82yxjbnaf2vqq6p3w38jq2id15a2yjg6wj810fl2286zz5ci3g3x7x0z0xdrxrrfvswns92v25197vpg0dki113lwdbw4bsvr"; }
  ];

  plexusInterpolation_1_15 = map (obj: fetchMaven {
    version = "1.15";
    artifactId = "plexus-interpolation";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0a3bvnmawbnqyva73pcz6mwwd9qsy2hrhjn708qmcplv7n21h06qyvzm5advlrrbqf7k55140vdh6nzvzlwvbw3ksbchdh4r85a9i4j"; }
    { type = "pom"; sha512 = "20z12w94g7pdmps9k3in3wmhirbz1qpgymfjpr5zx66kdiarj32b2akz28f5gr037zr3k3v366v3k3l694dx42rqhhwmalralybsj6a"; }
  ];
}
