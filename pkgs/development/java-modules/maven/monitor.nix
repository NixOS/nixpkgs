{ fetchMaven }:

rec {
  mavenMonitor_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-monitor";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2cxspfhf3sbz68y1kjqhw2lny6s1f1kf8sfad6f1qp653g4213c9yy7y3qk9szp528866vw7daa9gbymxd66k3bm09g1q4kgnkg5wn3"; }
    { type = "pom"; sha512 = "0h9brjzkvxfmk549wmq4mw71yhhf1qb1diin9rnsc5nlvh189k60088b5pcc14324gffkrvdghivfy8spjci5izmay87qk7hfsg2lxc"; }
  ];
}
