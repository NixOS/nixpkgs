{ fetchMaven }:

rec {
  plexusArchiver_1_0_alpha7 = map (obj: fetchMaven {
    version = "1.0-alpha-7";
    artifactId = "plexus-archiver";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3r1c5bknlk9010wqw1m6asqhnbmqz6xammhpci929gjjims27fr0c9qmskqr55vnbswcmvsiikfjnjwa36msgscirzsay48zrs5iwfk"; }
    { type = "pom"; sha512 = "05gnm321rx3zi5bnkgl64nbx6j8f3pz6y0v6nb3xfw44kgv7rxaq8b1v716wpr2p0bdrmarxmzidc92hps2w5src0ramg6xv35zfw6w"; }
  ];

  plexusArchiver_2_1 = map (obj: fetchMaven {
    version = "2.1";
    artifactId = "plexus-archiver";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0xwsvld0s5p4abk5ain2ya3zbz97bkk8vzjdrmfrly3mwfbxp7lyjhshxqnr58m7kan6l0vygv7lsnyfg0yyxmnj8f5nwvssgxm1izx"; }
    { type = "pom"; sha512 = "3rrwjlrwsl9ba7dyf5vp5r1pfvfmk4vwwpyq52yrmrv22djlh4dmbh1r97aizmrf17qbs7995vmcxs83ybpc62263dgxx1qa7c85hy1"; }
  ];
}
