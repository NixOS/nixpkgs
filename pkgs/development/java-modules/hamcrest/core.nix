{ fetchMaven }:

rec {
  hamcrestCore_1_3 = map (obj: fetchMaven {
    version = "1.3";
    artifactId = "hamcrest-core";
    groupId = "org.hamcrest";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "14vx453pk5shchdn3sz17s5im1cq1vav19rwnybafnsq2blfn3d0xz01cf9h1gnzclivhc4wgf7vvs23wcr7iiy4nksakxcb9rswdz2"; }
    { type = "pom"; sha512 = "3rn4bs9ixdnwg916qdkjjv9m17l0ym7zj6cxaf18304wlbshxcb1fpa11rnll9g76ap0f4z8r70z3snfj6kyf6sw9xf9xpq4n1796rg"; }
  ];
}

