{ fetchMaven }:

rec {
  mojoAnimalSniffer_1_11 = map (obj: fetchMaven {
    version = "1.11";
    artifactId = "animal-sniffer";
    groupId = "org.codehaus.mojo";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "36qx2q1zaja470zj7w3ygafb5n07vb623yicgwjqf1nak7ianin5nlmh7pp2pzpdd9arvg7d005rnsn79bqmxcb6y1ihsxsh6l7bmsv"; }
    { type = "pom"; sha512 = "1dp427c8vyiw255193s4m0ffag6ngqxfkj1cwl7v40p5c1bh8avxaj8cg56nn8ajp39shxr5wgwgjs7xwjz46yjnblh9pl29z58lm4i"; }
  ];
}

