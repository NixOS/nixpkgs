{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ctemplate";
  version = "2.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ctemplate.googlecode.com/files/${name}.tar.gz";
    sha256 = "0vv8gvyndppm9m5s1i5k0jvwcz41l1vfgg04r7nssdpzyz0cpwq4";
  };

  meta = {
    description = "A simple but powerful template language for C++";
    longDescription = ''
      CTemplate is a simple but powerful template language for C++. It
      emphasizes separating logic from presentation: it is impossible to
      embed application logic in this template language.  '';
    homepage = http://code.google.com/p/google-ctemplate/;
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
  };
}
