{ fetchMaven }:

rec {
  plexusCompilerApi_2_2 = map (obj: fetchMaven {
    version = "2.2";
    artifactId = "plexus-compiler-api";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3by7icjfiymp7g2v1ci5dqwml6ibzh2njyg2w43kvaz3ydcxkzmfg5s97wsdqjsii7vdgqyhr16ydsn6mr90wbjvsi6wasaq1rqa812"; }
    { type = "pom"; sha512 = "0pdl78hp921lgkfya54wl8hxgm1c5474j1p921q5ix1knx1rlr4klpjwx212wy2m7b6bxq0bkf8n66mqjr72rh2rh308qij00ymrga8"; }
  ];
}
