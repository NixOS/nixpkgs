{ fetchMaven }:

rec {
  plexusIo_2_0_2 = map (obj: fetchMaven {
    version = "2.0.2";
    artifactId = "plexus-io";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1z1il2fj5vr20g4aadwc0wkx117gffh8ql38i6ww5ldv9lppq81wmbsngj9vw434viy1rjifmwrx0ia3k66plqi3w63x86igq7ka0hk"; }
    { type = "pom"; sha512 = "3wlqpr3b8gw9kphnqkwbxmd5pmis9wkp31biqaa6qmib31k3az6qk81fd8bwr6ifpki11fabawzbmg0dnabxig8svg6c49ydgjm3p8p"; }
  ];
}
