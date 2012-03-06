{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jetty-gwt-6.1.14";
  src = fetchurl {
    url = http://repository.codehaus.org/org/mortbay/jetty/jetty-gwt/6.1.14/jetty-gwt-6.1.14.jar;
    sha256 = "17x8ss75rx9xjn93rq861mdn9d6gw87rbrf24blawa6ahhb56ppf";
  };
  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/$name.jar
  '';
}
