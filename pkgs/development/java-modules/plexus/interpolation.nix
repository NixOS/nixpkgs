{ fetchMaven }:

rec {
  plexusInterpolation_1_13 = map (obj: fetchMaven {
    version = "1.13";
    baseName = "plexus-interpolation";
    package = "/org/codehaus/plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0sm1kaxsvn8007br7nr9ncjppmfkp8nzr6ipwwx86idai9bqcsm4kh2scxf893s4jf2ii7f5106dd5w4h7bw67csalhqqzi1zpndbk4"; }
    { type = "pom"; sha512 = "3hlv9l82yxjbnaf2vqq6p3w38jq2id15a2yjg6wj810fl2286zz5ci3g3x7x0z0xdrxrrfvswns92v25197vpg0dki113lwdbw4bsvr"; }
  ];
}
