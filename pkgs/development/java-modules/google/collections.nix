{ fetchMaven }:

rec {
  googleCollections_1_0 = map (obj: fetchMaven {
    version = "1.0";
    artifactId = "google-collections";
    groupId = "com.google.collections";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3vvgac799ilrmab28ya894jkyq3jj4217ix8mfyxzbkb8v0wy2rpmdbni3irrrdhc9skd0sldlcnfpvs1hjv5v07ajxlm1dbkgvqhap"; }
    { type = "pom"; sha512 = "38x885cglwmx0chqlzhx83jcrqvnwwr9qj6awx3n0xqp175qznjwn0i94rwxhyj00a7xgvvm9jvwkppwfkcdiyxmimb1z8frdhkkh7p"; }
  ];
}

