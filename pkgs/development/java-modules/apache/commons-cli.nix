{ fetchMaven }:

rec {
  commonsCli_1_0 = map (obj: fetchMaven {
    version = "1.0";
    artifactId = "commons-cli";
    groupId = "commons-cli";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1pm5ba95viabcgpjhsqw21iwis9ajn8hwpyc6rzs9frr5k62hs7lj8darxmmp21hf14mxrs37a8swayhagq6i6g8js4nl4r8mmwjlvp"; }
    { type = "jar"; sha512 = "0ybdbpfzadkncwcmnzkscbp2fhmcsqmpy60qppz7s8hs00hgqy64jr4qpdyz5bj0l4bc434vn0pv4gzxzi7y1lhh7b2rk4zv1mgs3ff"; }
  ];

  commonsCli_1_2 = map (obj: fetchMaven {
    version = "1.2";
    artifactId = "commons-cli";
    groupId = "commons-cli";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3lrjnrkq0vq1mjp1z6zbi6x0x45hj20yvs74aqnpzayd0prwv22hyfyadgrj343is54s6m2p5mx2kpziqz9wcih5hmwg5f80ni8mxp7"; }
    { type = "jar"; sha512 = "2mdzpng0cybpnw5dw1q4dmpn2i89zhg13m8xjv8pdbn5q28zsf8m3m7w0y8irbjyplwrfdrxipkxxvnz5f61bxi4s85hnm0sc84d3qb"; }
  ];
}
