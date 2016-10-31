{ fetchMaven }:

rec {
  mavenMonitor_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-monitor";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3ssw8r9qdhbvi21y8lqz39aml2l9pzw4g26hvlh3rbshvhhgsm672jl1pv8z5pbs73w7px6dnz1yhcf7l5df53apfzq0fggrw9fsnhz"; }
    { type = "pom"; sha512 = "2wdvc5r3bsrml3w6nbym9flyj3ryj308bbfmns156p9pincc73pppad5cgyv4wrwjnmwp6qfbjsz90k6481v4li88a78nmc8lhmhylr"; }
  ];

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

  mavenMonitor_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-monitor";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "20yjvzy683ngrpkng4nv82vw081mwsqrmdmlsd66axj9w0sjk4s1d87d3b3jdjhqk4jn4f7vnm644awv17g9pxqvfk1shsn83lbnvi2"; }
    { type = "pom"; sha512 = "1pqh6viikr8py8spmp1l55rcsqizsa1cv6kpycmpikj59bnxhd1kqj24rhn485ifam9i90w0p5yywmgg3fmvc09byfnfl5z2lf8j5dj"; }
  ];
}
