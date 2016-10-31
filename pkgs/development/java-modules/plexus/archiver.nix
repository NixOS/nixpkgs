{ fetchMaven }:

rec {
  plexusArchiver_2_1 = map (obj: fetchMaven {
    version = "2.1";
    baseName = "plexus-archiver";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0xwsvld0s5p4abk5ain2ya3zbz97bkk8vzjdrmfrly3mwfbxp7lyjhshxqnr58m7kan6l0vygv7lsnyfg0yyxmnj8f5nwvssgxm1izx"; }
    { type = "pom"; sha512 = "3rrwjlrwsl9ba7dyf5vp5r1pfvfmk4vwwpyq52yrmrv22djlh4dmbh1r97aizmrf17qbs7995vmcxs83ybpc62263dgxx1qa7c85hy1"; }
  ];
}
