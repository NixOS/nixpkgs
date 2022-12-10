{ fetchMaven }:

{
  mavenCompiler_3_2 = map (obj: fetchMaven {
    version = "3.2";
    artifactId = "maven-compiler-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "15lncacbgsbkp6m4fb1hv41nxn0w8lxgpjcpghw3znbh909d2y5h70q2nw3fyhd7kqsjwpvwpilkgyd5b35vi1smj5hhapmakqjk28r"; }
    { type = "pom"; sha512 = "0a9pnb9rscsc32gpjr257k1pnydpskcs4jx8bs88vikxbdgc5sppllmqhi7k00i19azy2vjj59b3m9dcklcspmy9caxv2l7vjyr2lm0"; }
  ];
}
