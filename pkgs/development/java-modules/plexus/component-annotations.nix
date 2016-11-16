{ fetchMaven }:

rec {
  plexusComponentAnnotations_1_5_5 = map (obj: fetchMaven {
    version = "1.5.5";
    artifactId = "plexus-component-annotations";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2r0dzjs65hzllvm7kizis0lmx4sp3967c1918181y0isnlp1fsxg8sakb2qnfn748xnnxgh7h5fk04az999isd8qs1p85cgi2waz91f"; }
    { type = "pom"; sha512 = "1yx9dl3mq8wx3w4ksq0z1x84kry1l1agdg3ssnbjwxlh96hjxki88j89iyfwbwwia40113b62r8168s0lhgzca3w7kbdii3kldgbz6y"; }
  ];
}
