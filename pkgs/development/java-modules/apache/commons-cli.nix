{ fetchMaven }:

rec {
  commonsCli_1_0 = map (obj: fetchMaven {
    version = "1.0";
    baseName = "commons-cli";
    package = "/commons-cli";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1pm5ba95viabcgpjhsqw21iwis9ajn8hwpyc6rzs9frr5k62hs7lj8darxmmp21hf14mxrs37a8swayhagq6i6g8js4nl4r8mmwjlvp"; }
    { type = "jar"; sha512 = "0ybdbpfzadkncwcmnzkscbp2fhmcsqmpy60qppz7s8hs00hgqy64jr4qpdyz5bj0l4bc434vn0pv4gzxzi7y1lhh7b2rk4zv1mgs3ff"; }
  ];
}
