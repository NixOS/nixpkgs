{ fetchMaven }:

rec {
  mavenPluginAnnotations_3_1 = map (obj: fetchMaven {
    version = "3.1";
    baseName = "maven-plugin-annotations";
    package = "/org/apache/maven/plugin-tools";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "17zyw3j4zbg1hhj18i4q1f0r8gdxl3q9x5ksyqlyr0mrw2sadc6lvbbhyp3l7vsbddl4bgdx36gwvjp5d97gbmk1nbpi1vabadfhq76"; }
    { type = "jar"; sha512 = "0rk2nzkwcrkfy3vs0zl0l2lxp3w4hkwxrypisbivv5al7sc8lbzls6jgpp3h5gx9kk4scjj24qf5vyimnbadj63rvqffg581fs2zgl9"; }
  ];
}
