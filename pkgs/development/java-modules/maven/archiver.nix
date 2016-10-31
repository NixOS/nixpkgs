{ fetchMaven }:

rec {
  mavenArchiver_2_5 = map (obj: fetchMaven {
    version = "2.5";
    baseName = "maven-archiver";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3kkv5kf3k5in69aplawkr0cr2cviyjgf8k6r6qvgxk53i3jmh7qylzrwkrd9bxclkjkgyg77cffxm48qhxm9pyqncdbwjldsmmdfb4f"; }
    { type = "pom"; sha512 = "37kvfxcpfajjn9lmvh5kay4y61ri1190hxxgiil8fqfvmvcm02jcqzfi4ry0nzc80g5fsarsd3s2ns2d8l0lnqjp28nn51dixm9a55w"; }
  ];
}
