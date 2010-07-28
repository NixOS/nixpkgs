{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "jruby-1.1.6";

  src = fetchurl {
    url = http://dist.codehaus.org/jruby/1.1.6RC1/jruby-bin-1.1.6RC1.tar.gz;
    sha256 = "1q3cjshxk484i8gqxm682bxcrps7205nl9vlim4s6z827bjlmc4a";
  };

  installPhase = '' ensureDir $out; cp -r * $out '';

  meta = { 
    description = "Ruby interpreter written in Java";
    homepage = http://jruby.codehaus.org/;
    license = "CPL-1.0 GPL-2 LGPL-2.1"; # one of those
  };
}
