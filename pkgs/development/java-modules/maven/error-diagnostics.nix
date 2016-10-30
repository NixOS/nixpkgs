{ fetchMaven }:

rec {
  mavenErrorDiagnostics_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-error-diagnostics";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3czdrv2s1gafclm57m5qxw3aaxrm3r3z9yggscxg60fk0hn6jlpygclghkrl2g7c8ggdqdd01y6zcj1wgzq32yp1cd4s3kakf2y25dm"; }
    { type = "pom"; sha512 = "3l0cpg0ssivfnadffc68cnac65vpfpl0qa9a4ik82jxcwhfa00337jxz37vyqaqs1vjrvd2cqhmjayddwkpwc8aqnz3nr0rlqnqzm7g"; }
  ];
}
