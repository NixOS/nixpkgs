{ fetchMaven }:

rec {
  plexusDigest_1_0 = map (obj: fetchMaven {
    version = "1.0";
    artifactId = "plexus-digest";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0r343fhzhfdnavsjbl7jnxgdw64wsfzyk4q7l3m7s5wx3b8mxnizyg1r4fwb59bd8w8hw6x8l0nxrk16a9hnkhrdmnc01hyb3ra7irk"; }
    { type = "pom"; sha512 = "1z7nqj2qa82g8dgd4jzmankz3hkh4r8y1q0abd37kwsx54ij681d46z916w009mq232jharynypg3682ds47jxxnqsmpm9k22i7fgib"; }
  ];
}
