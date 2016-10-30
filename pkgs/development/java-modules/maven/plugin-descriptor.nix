{ fetchMaven }:

rec {
  mavenPluginDescriptor_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-plugin-descriptor";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0q9jw44v1mi489bqmdvj7jpv753vdp9jzp50ky6pd912x190spkw6ccmpc87azmwsf131d4h0k0fqi6iidl9ip22a8rwaa22yq7gxi8"; }
    { type = "pom"; sha512 = "0c4hrb6qhi8wxw7acyphv6l33973vhvg7vjknc3bx8bg36404ky9k78q79r3p2an2886hdfayb0l7wji86bq4q8464754gbx02ci7r8"; }
  ];
}
