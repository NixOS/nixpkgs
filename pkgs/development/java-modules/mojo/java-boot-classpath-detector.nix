{ fetchMaven }:

rec {
  mojoJavaBootClasspathDetector_1_11 = map (obj: fetchMaven {
    version = "1.11";
    artifactId = "java-boot-classpath-detector";
    groupId = "org.codehaus.mojo";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0dn0ry30n47544bbhp8j3r5fm6ip7cs1i8wg0wdfr735ak7r38wpb297q0k5kfaqrlqwi8cmnz4lngjan223lpwywjc806v27adjh57"; }
    { type = "pom"; sha512 = "1ndzid9lik3a3bh8d2n9fqql29wypx4cw4ybvjgqhx63rs8hbb038irmcdr18jsalb8v2sj0bmjv6nmrr58wgf158r1zjv311m95yw0"; }
  ];
}
