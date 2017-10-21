{ fetchMaven }:

rec {
  mavenFiltering_1_1 = map (obj: fetchMaven {
    version = "1.1";
    artifactId = "maven-filtering";
    groupId = "org.apache.maven.shared";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "022n451vgprms5rp26iynlg7yn7p1l71d5sd5r177dmw0250pvrr5gvjrriq8fis2rxbdhr42zl1xm2mmzlg6sj55izzy03dwryhydn"; }
    { type = "jar"; sha512 = "33ing5r916n71skj75cikhrapns28l6ryxw9q3yn5hyqzsbj2yk7lzss87ardg9j3wkmb4rpj9mkb63w0fljwjfpbja6qmzxrybj5rp"; }
  ];
}
