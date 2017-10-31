{ fetchMaven }:

rec {
  mavenPluginDescriptor_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-plugin-descriptor";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2gwjmn4xnxh2hy9nnlr107q1fpnyy2yhkajvj2snpl1xmpn76m1vvj64zf52l9grpvpx91b0pvd8pxa8hzmh8kqdf1w3wqjg5k1p4zf"; }
    { type = "pom"; sha512 = "0g9hl6i0kqfrifjmykrg5pfb2xh35by3dc1nfa4i1434xr1fzi4y5avdqaw3zlvhnybi611qxv1g2ydnwkq9mgnvjq8fis4ir60g82s"; }
  ];

  mavenPluginDescriptor_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-plugin-descriptor";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0f23srb1clkmvq05rcmv8gn7lifaw5f1i2vqyn2cfnhgcmp9i32xsbhqpx9y0rqlv6497x80dck7xylp22d3hnqkpm3pxgws9wsz7sm"; }
    { type = "pom"; sha512 = "10hra81gs8swq00k4rw3ip8wr9gl4d7vd3621ga4298b466wic7sbb9fy9ifw22q49ia7hkigqi4ha73q7kmrl7ihnb9iv4vil02yj6"; }
  ];

  mavenPluginDescriptor_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-plugin-descriptor";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0q9jw44v1mi489bqmdvj7jpv753vdp9jzp50ky6pd912x190spkw6ccmpc87azmwsf131d4h0k0fqi6iidl9ip22a8rwaa22yq7gxi8"; }
    { type = "pom"; sha512 = "0c4hrb6qhi8wxw7acyphv6l33973vhvg7vjknc3bx8bg36404ky9k78q79r3p2an2886hdfayb0l7wji86bq4q8464754gbx02ci7r8"; }
  ];

  mavenPluginDescriptor_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-plugin-descriptor";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "34pf7z07gba3a3mvn3q3324bfrlzz01ycf02a31m2daxr12427hczz3ml4jd0gjsjj36qwic89wpcb7p34px3lvgkvy1d5hz0ky6nh6"; }
    { type = "pom"; sha512 = "2z3kchasac2jbw1n0zq6d5ym57yw6si7d5i7qhz81q3ripv7r19is4d459idymgcqgpdp98zaqg7dbcbz72d0p6k9g8ngaqgk2iml0x"; }
  ];
}
