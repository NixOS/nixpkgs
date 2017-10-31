{ fetchMaven }:

rec {
  antLauncher_1_8_2 = map (obj: fetchMaven {
    version = "1.8.2";
    artifactId = "ant-launcher";
    groupId = "org.apache.ant";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3h1xmlamkh39lz3dgpbyxj0mai9a266qmxkcyb7kqpzkl0xxvgyi8i2l4nnn02n4qbxznhmvsba77v52ldh67qmhxk3vw1q3xqnn2xx"; }
    { type = "pom"; sha512 = "3fvz9di9lbfgy5370gwwdp2d380gl42sn44kr97l8i7k0n9crrbjrxs2dpy9cnsnnavvk14nrrkc72n9f1gkg1dvdxqpxlwm0y9lxhy"; }
  ];
}
