{ fetchMaven }:

rec {
  plexusBuildApi_0_0_4 = map (obj: fetchMaven {
    version = "0.0.4";
    artifactId = "plexus-build-api";
    groupId = "org.sonatype.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0ihr946rd2cwc1qsi8g104vpyz1ml5ypl3374z3rhlmm4i0xgn6vsa9sg8bnh1848klhxsp11i0gm4adg6lzk3s88mqm5b4wlbsdvv2"; }
    { type = "pom"; sha512 = "1135ca387fvzjb04j8z93jmy61zpi2w7a6c6rq9xxk33xz9nxzzwvca7k40j6jsj0bmjbswrpdck7qh2921rn3j4vfsihbi9g7mb31r"; }
  ];
}
