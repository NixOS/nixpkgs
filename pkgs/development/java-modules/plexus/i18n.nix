{ fetchMaven }:

rec {
  plexusI18n_1_0_beta6 = map (obj: fetchMaven {
    version = "1.0-beta-6";
    artifactId = "plexus-i18n";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "28j0h3qd2xpddcs9wxr30235a8l1jlqwj7mhbvdhqcn8ck2bbp7dx1bl9p8mzl1v6lgzqi12ga6lccs2axadmz0w7fscvzmfh2v8mvk"; }
    { type = "pom"; sha512 = "1zv1v86vqzmk03mvl1i74wqk5s2b0wgr6qksdnjp7msmm8k27ilbgsdf9nf9wfc84s4kw4xwwkg954x192klwmv16kslc6xqjbxl2gk"; }
  ];
}
