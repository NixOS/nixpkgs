{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jetty-util-6.1.16";
  src = fetchurl {
    url = http://repository.codehaus.org/org/mortbay/jetty/jetty-util/6.1.16/jetty-util-6.1.16.jar;
    sha256 = "1ld94lb5dk7y6sjg1rq8zdk97wiy56ik5vbgy7yjj4f6rz5pxbyq";
  };
  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/$name.jar
  '';
}
