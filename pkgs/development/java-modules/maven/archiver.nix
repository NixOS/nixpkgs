{ fetchMaven }:

rec {
  mavenArchiver_2_5 = map (obj: fetchMaven {
    version = "2.5";
    artifactId = "maven-archiver";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0wx6248rn0821nnag659mm1n77r56chgx2lr26x81l7apx4zkc2nidjzy2d73snkir98h9bmcz09wnx21pkrq8mk50x7mjgkc0yziky"; }
    { type = "pom"; sha512 = "1rfnwxnk45084rdc52a17bmg8zfyylq1m38wvp956xy455abjvxpnp7il7xpkq6wv16f3bq5yx35hk1b9nycw19w6123rz4v5cs3b0b"; }
  ];
}
