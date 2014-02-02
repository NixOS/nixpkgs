{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libyaml-0.1.4";

  src = fetchurl {
    url = http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz;
    sha256 = "0dvavrhxjrjfxgdgysxqfpdy08lpg3m9i8vxjyvdkcjsmra1by3v";
  };

  # Downloaded on 2014-02-01 from https://bugzilla.redhat.com/show_bug.cgi?id=1033990
  patches = [ ./cve-2013-6393_a.patch ./cve-2013-6393_b.patch ./cve-2013-6393_c.patch ];

  meta = {
    homepage = http://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = "free";
  };
}
