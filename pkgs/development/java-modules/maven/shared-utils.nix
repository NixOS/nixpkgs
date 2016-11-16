{ fetchMaven }:

rec {
  mavenSharedUtils_0_1 = map (obj: fetchMaven {
    version = "0.1";
    artifactId = "maven-shared-utils";
    groupId = "org.apache.maven.shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0xf4pb0bh2kr3qx1yqav528886fdvsb801mq22hnbs8cbaghgibcb0n8w6rbiyd59y1fmiacyhhcc18ahcxv71531m704w5gydrwx9k"; }
    { type = "pom"; sha512 = "0w5ryz3kdx6c10bwhbdpic567cf1b4918anncls9gzy89lfc4lj4lnyhapv7lsfp3fzifas618m7mh4pv5gdpjbml3fgjnqcq6895g6"; }
  ];
}
